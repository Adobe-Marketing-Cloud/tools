#!/bin/bash

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
