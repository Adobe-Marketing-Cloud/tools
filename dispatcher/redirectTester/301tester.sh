#!/bin/bash
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