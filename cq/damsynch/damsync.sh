#!/bin/bash
###############################################################################
#
# ADOBE CONFIDENTIAL
# __________________
#
#  Copyright 2013 Adobe Systems Incorporated
#  All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of Adobe Systems Incorporated and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to Adobe Systems Incorporated and its
# suppliers and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from Adobe Systems Incorporated.
#
###############################################################################

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
VERSION=1.2

# Initialize our own variables:
output_file=""
recursive=0
dry=0
authorization=admin:admin
uri=http://localhost:4502/content/dam
folder=""
total=0
total_size=0
total_time=0
num=1

hash curl 2> /dev/null || { echo "curl not found. please ensure that it is installed"; exit 1; }

show_version(){
    echo "damsync $VERSION. Copyight 2013 Adobe Systems Incorporated. All Rights Reserved"
}
show_help(){
    show_version
cat << EOF

Usage
-----
    damsync.sh -rvn -a <user:pwd> -u <uri> -p <path> files...

Options
-------
    -h           : show this help
    -v           : show version and exit
    -a user:pwd  : user and password for connecting to the repository (admin:admin)  
    -u uri       : URI of DAM root folder (http://localhost:4502/content/dam)
    -p path      : additional dam folder path.
    -r           : recursive
    -n           : dry run
    <files>      : list of files and directories to sync

Examples
--------

Upload all files in "photos" to the DAM folder "myphotos":

    $ damsync.sh -p myphotos -r photos

Upload all the pngs on the desktop to the DAM folder 'images':

    $ damsync.sh -p images ~/Dekstop/*.png

Upload 1 asset to the publish on https:

    $ damsync.sh -u https://localhost:8443/content/dam/geometrixx myasset.png

EOF
}

filesize() {
  stat -f"%z" "$1" 2> /dev/null
  if [ $? -ne 0 ]; then
      stat -c"%s" "$1"
  fi
}

urlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9/] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

upload(){
    local file="$1"
    if [[ ! -e "$file" ]]; then
      echo "Warning: file $file does not exist."
      return 0
    fi
    urlencode "$file"
    local path=$REPLY
    local dst="$uri/$path"
    tput sc; # remember beginning of line
    printf "A %${numpad}d/%d %s..." $num $total "$dst"

    curl_opts="-sSfo /dev/null"
    if [[ $verbose -eq 1 ]]; then
        curl_opts="$curl_opts -v"
    fi

    if [[ $dry -eq 1 ]]; then
        t=0.01
    else 
      local tmpfile="$(mktemp -t damsync.XXXXXXXXXX)"
      local t=$(TIMEFORMAT=%R; ( time \
        curl -u $authorization \
            $curl_opts \
            -F jcr:content/renditions/original=@"$file"  \
            -F jcr:primaryType=dam:Asset \
            -F jcr:content/jcr:primaryType=dam:AssetContent \
            -F jcr:content/renditions/jcr:primaryType=nt:folder \
            "$dst" 2> $tmpfile) 2>&1 > /dev/null)
    fi
    curl_error=$(cat $tmpfile)
    rm -rf $tmpfile
    if [[ -n "$curl_error" ]]; then
        echo "  error: $curl_error"
        return;
    fi
    local s=$(filesize "$file")
    local r=$(bc <<< "scale=2; $s / $t / 1048576")
    total_size=$(bc <<< "$total_size + $s")
    total_time=$(bc <<< "scale=4;$total_time + $t")
    local numlines=`tput cols`
    local output=$(printf '%s in %ss (%4.2fMB/s)' $s $t $r)
    tput cub 3; tput el; tput rc; 
    tput cuf $[$numlines - ${#output}]
    echo $output
    num=$[num+1]
}

while getopts "h?vnra:u:p:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  show_version
        exit 0
        ;;
    r)  recursive=1
        ;;
    n)  dry=1
        ;;
    a)  authorization=$OPTARG
        ;;
    u)  uri=$OPTARG
        ;;
    p)  folder=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift
[ "$1" = "" ] && show_help && exit 1

find_opts=""

if [[ -n "$folder" ]]; then 
    uri=$uri/$folder
fi  

if [[ $recursive -eq 0 ]]; then 
    find_opts="-maxdepth 1"
fi

for file in "$@"; do
    if [[ -d "$file" ]]; then 
      total=$[total+$(find "$file" $find_opts -type f | wc -l)]
    else
      total=$[total+1]
    fi
done

numpad=${#total}
tmpfile="$(mktemp -t damsync.XXXXXXXXXX)"
while test $# -gt 0; do
    cwd=`pwd`
    if [[ -d "$1" ]]; then 
      cd "$1"
      find . $find_opts -type f -print0 > $tmpfile 
      while read -d $'\0' file; do upload "$file"; done < $tmpfile
      rm -rf $tmpfile
    else
      cd `dirname "$1"`
      upload "`basename "$1"`"
    fi
    cd "$cwd"
    shift
done

total_ratio=$(bc 2> /dev/null <<< "scale=2; $total_size / $total_time / 1048576") 

echo "Uploaded $total assets $(bc <<< "scale=2;$total_size/1048576")MB in ${total_time}s (${total_ratio}MB/s)"








