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

#  original author  Elaine Sun, Adobe
#  since 2014-09-05

request_log=$1
num=$2
result=$3

usage() {
echo "
This is a series of small scripts that are intended to help troubleshoot performance related AEM issues. You may find them useful if you do the following related to AEM: 1) address production issues 2) tune performance 3) Analyze system usage. They need to be run in *nix environment with bash shell where AEM author or publisher request.log, access log, thread dump or whatever input it required can be found.

This one helps find the requests that have been amongst the most frequent based upon an AEM author or publisher request log, and put result in provided file location. This helps identify requests that are not essential to the site but consume way too much resources on author or publisher.

It has been tested with AEM5.6.1 and Redhat 6.4. Your mileage may vary. You are encouraged to monitor the system while the script is running to make sure that it does not take too much resource from your critical system processes.

Usage: <request_log_complete_path> <number_of_slowest_quries> <result_file_complete_path>
"
}

if [ $# -lt 3 ] 
then 
usage
exit
fi

if [ -f ${result} ]
then
echo ${result} already exists where you want to store results
exit
fi

grep "\->" ${request_log} | awk '{print $5 " " $6}'  | cut -d"?" -f1 | sort | uniq -c | sort -nr | head -${num} >> ${result}
