Redirect Tester
=====

This script tests redirects, which is useful when planning to do a DNS cutover to a new site implementation.  Expects an input file in the format of oldUrl|newUrl with a old/new pair on each line.  Note that the input file MUST end with a new line.  The script will check for correct redirect status and destination, outputting the results in a greppable format.  Run as ./301tester.sh myInputFile.txt >> outputLog.txt
