#!/bin/bash
request_log=$1
url=$2
# example: ./get_response_time_by_url.sh /mnt/crx/publish/crx-quickstart/logs/request.log  "/etc/segmentation.segment.js"
for request_id in `grep " $url " $request_log | awk '{print $3}' | cut -d[ -f2| cut -d] -f1`; do grep "\[$request_id\]" $request_log; done
