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
#############################################################################

# original author  Elaine Sun, Adobe
# since   2013-09-20

request_log=$1
num=$2
result=$3

usage() {
echo "
This is a series of small scripts that are intended to help troubleshoot performance related AEM issues. You may find them useful if you do the following related to AEM: 1) address production issues 2) tune performance 3) Analyze system usage. They need to be run in *nix environment with bash shell where AEM author or publisher request.log, access log, thread dump or whatever input it required can be found.

This one helps find the requests that have been amongst the slowest based upon an AEM author or publisher request log, put result in provided file location. 

It has been tested on Redhat 6.4. Your mileage may vary. You are encouraged to monitor the system while the script is running to make sure that it does not take too much resource from your critical system processes.

Usage: <request_log_complete_path> <number_of_slowest_quries> <result_file_complete_path>
"
}

if [ $# -lt 3 ] 
then 
usage
exit
fi

if [ -e ${result} ]
then
echo ${result} already exists where you want to store results. Please choose another location.
exit
fi

for x in `awk '{print $7}' $request_log | sort -nr | head -$num`; do request_end_line=`grep $x $request_log`; request_id=`echo $request_end_line | awk '{print $3}' | cut -d[ -f2| cut -d] -f1`; grep "\[$request_id\]" $request_log >> ${result}; done;

