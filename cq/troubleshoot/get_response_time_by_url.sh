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
#  since   2014-09-05

request_log=$1
url=$2
# example: ./get_response_time_by_url.sh /mnt/crx/publish/crx-quickstart/logs/request.log  "/etc/segmentation.segment.js"
for request_id in `grep " $url " $request_log | awk '{print $3}' | cut -d[ -f2| cut -d] -f1`; do grep "\[$request_id\]" $request_log; done
