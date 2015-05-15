#!/bin/bash

#############################################################################
# Copyright 2015 Adobe
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
#  original author  Ian Reasor, Adobe
#  since   2015-02-23
#############################################################################

#Checks redirects.  Expects an input file in the format of oldUrl|newUrl.
#Note that the input file MUST end with a new line.
#Will check for correct redirect status and destination, outputting the results in a greppable format.
#Run as ./301tester.sh myInputFile.txt >> outputLog.txt

IFS='|';
REDIRECT_STATUS="301";

while read -ra line
do
    oldUrl=${line[0]}
    newUrl=${line[1]}
    
    old_IFS=$IFS
    IFS=$'\n';
    curlOutput=($(curl -is $oldUrl))    
    rawStatus=$(echo ${curlOutput[0]} | tr -cd '\11\12\40-\176') #scrub special characters
    status=$(echo $rawStatus | sed -n 's/.*\([0-9][0-9][0-9]\).*/\1/p') #extract status code
    rawLocation=$(echo ${curlOutput[4]} | tr -cd '\11\12\40-\176') #scrub special characters
    location=$(echo $rawLocation | sed -n 's/Location: \(.*\)/\1/p') #extract URL
    IFS=${old_IFS}
    
    result="Good"    
    if [[ "$status" != "$REDIRECT_STATUS" ]] || [[ "$location" != "$newUrl" ]] ; then
        result="Bad"
    fi
    
    echo $result"|"$status"|"$oldUrl"|"$location
done < $1