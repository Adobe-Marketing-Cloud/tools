Adobe CQ DAM Synchronization script 
===================================

Overview
--------
This simple script allows to easily upload DAM assets from the filesystem into a CQ DAM system. The script can recursively recreate folder structures if the `-r` option is specified.

**Note** The current version does not actually synchronize but just upload all specified assets. No matter if they already exists in DAM or not.

Usage
-----
    damsync.sh -rvn -a <user:pwd> -u <uri> -p <path> files...

Options
-------
    -h           : show this help
    -a user:pwd  : user and password for connecting to the repository (admin:admin)  
    -u uri       : URI of DAM root folder (http://localhost:4502/content/dam)
    -p path      : additional dam folder path.
    -r           : recursive
    -v           : show version and exit
    -n           : dry run
    <files>      : list of files and directories to sync

Examples
--------

Upload all files in "photos" to the DAM folder "myphotos":

    $ damsync.sh -p myphotos -r photos

Upload all the pngs on the desktop to the DAM folder 'images':

    $ damsync.sh -p images ~/Dekstop/*.png

Upload 1 asset to the publish on https:

    $ damsync.sh -u https://localhost:8443/content/dam/geometrixx myasset.png

Known Bugs
----------
* upload fails if intermediate folder can't be auto created.
  Damsync is using the sling post servlet in a very simple fashion and relies on the 
  servlet begin able to auto create intermediate nodes.


Changes
-------
### version 1.2
* minor adjustments to make it work under linux

### Version 1.1
* improved output
* added upload metrics


### Version 1.0
* Initial Version