#! /bin/sh

# A few defaults
LOGIN_URL="http://www.imobilco.ru/login/"
BADOPTSHELP="Option is not recognized"
DEST_DIR="/Volumes/media/BitTorrent/Детские/"
URLQUEUE_FILE="queue.txt"
URL_LIST=""

function showUsage {
	cat <<EOT

getFilesFromIMobilco [options] [file_url]

Options:
	-u		Specify iMobilco user name
	-p		Specify iMobilco password
	-q		Specify alternate URL queue file (in this case file_url is ignored).
			Default is queue.txt in current directory.
	-d		DEST_DIR directory
	-h		Shows this

EOT
	exit
}

# just print error and exit
function printErrorHelpAndExit {
	echo $1
	exit
}

# read in queue file with URLs, one URL per line. See sample file queue.txt
function readDownloadLinks {
	URL_LIST=$(cat $URLQUEUE_FILE | egrep -v '^#' )
}

function getFiles {
	readDownloadLinks
	cd $DEST_DIR
	for url in $URL_LIST
	do
		curl --cookie-jar cjar --location \
			--data login=$ULOGIN \
			--data password=$UPASSWD $LOGIN_URL
		echo Fetching $url...
		curl --cookie cjar --location --remote-name $url
	done
}


# let it all begin
#args=`getopt hd:q:u:p: $*`

while getopts "hd:q:u:p:" optionName; do
	case "$optionName" in
		u)	ULOGIN="$OPTARG";;
		p)	UPASSWD="$OPTARG";;
		q)	URLQUEUE_FILE="$OPTARG";;
		d)	DEST_DIR="$OPTARG";;
		h)	showUsage;;
		[?]) printErrorHelpAndExit "$BADOPTSHELP";;
	esac
done

getFiles

# EOF
