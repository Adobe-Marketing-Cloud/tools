#!/bin/bash

#############################################################################
# Copyright 2013 Adobe
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
#  limitations under the License.
# 
#  original author  Elaine Sun, Adobe
#  since   2014-09-05
#############################################################################

usage() {
echo "
This is a series of small scripts that are intended to help troubleshoot performance related AEM issues. You may find them useful if you do the following related to AEM: 1) address production issues 2) tune performance 3) Analyze system usage. They need to be run in *nix environment with bash shell where AEM author or publisher request.log, access log, thread dump or whatever input it required can be found.

This one helps find the requests that have not been completed based upon AEM author or publisher request log, put result in provided file location, using an optional request URL pattern. This can help find slow requests that have gone on for long time. 

It has been tested with AEM5.6.1 and Redhat 6.4. Your mileage may vary. You are encouraged to monitor the system while the script is running to make sure that it does not take too much resource from your critical system processes.

Warning: if no URL pattern is present to limt the scope of search, depending upon how busy your site is and how powerful your machine is, the script may run for a while!

Usage: <request_log_complete_path> <result_file_complete_path> <optional_url_pattern>"
}

if [ $# -lt 2 ] 
then 
usage
exit
fi

request_log=$1
result=$2
url_pattern=$3

if [ -e ${result} ]
then
echo ${result} already exists where you want to store results
exit
fi

requestids=/tmp/incomplete_requestids_`date '+%m%d%Y_%H%M'`

cat /dev/null > ${requestids}

if [ $# -eq 3 ]
then
grep "${url_pattern}" ${request_log} | awk '{print $3}' | cut -d[ -f2| cut -d] -f1 > ${requestids}
else
grep " \-> " ${request_log} | awk '{print $3}' | cut -d[ -f2| cut -d] -f1 > ${requestids}
fi

for x in `cat ${requestids}` 
do 
request_end_line=`grep -c "\[$x\]" $request_log`; 
[[ ${request_end_line} -le 1 ]] && grep $x ${request_log} >> ${result}; 
done;

