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
# since   2013-12-05

usage() {
echo "
This is a series of small scripts that are intended to help troubleshoot performance related AEM issues. You may find them useful if you do the following related to AEM: 1) address production issues 2) tune performance 3) Analyze system usage. They need to be run in *nix environment with bash shell where AEM author or publisher request.log, access log, thread dump or whatever input it required can be found.

This one processes a thread dump sorted by the amount of time that a thread has been running, descending. This is another way to find slow requests that have been going on for long time and allow one to quickly get an overall view how things are running (or waiting, timed_waiting, blocking) to help narrow down suspect lists for a deeper dive on the stack trace. 

Usage: $0 <thread_dump_complete_path>

"
}

if [ $# -lt 1 ]
then
usage;
exit;
fi

thread_dump=$1
for x in `egrep " \[[0123456789]+]" ${thread_dump} | awk '{print $2}' | cut -d\[ -f2 | cut -d] -f1 | sort -n`; do date -d @$(( $x / 1000 )); grep $x ${thread_dump} ;done
