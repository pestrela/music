#!/bin/bash

#
# Pre-requisites / notes:
#   to disable MAC NFS caching: https://support.apple.com/en-us/HT208209
#     alternative: copy script into new file
#
#   to start NFS share:  
#      finder / go /connect to server / smb://192.168.56.1/ / NFS_share_macOS
#      terminal / cd /Volumes/NFS_share/2\ DJCU scripts/
#
#   to delete rekordbuddy database:
#      struss 
#      /Users/pedro/Music/Rekord Buddy/
#    
#
# Process:
#   a) c:/root/sync_traktor/Traktor Config/4_Configuration_Dir/collection.nml
#   b) /Users/pedro/Documents/Native Instruments/Traktor 2.11.2/collection.nml
#        run rekordbuddy2
#   c) /Users/pedro/Library/Pioneer/rekordbox/rekordbox.xml
#   d) c:/root/sync_traktor/Traktor Config/Rekordbox Config/rekordbox XML/rekordbox.xml
#

set -x
set -e
set -u

DELETE_WORK_FILES=true

BASE_DIR="/Volumes/NFS_share_MacOS"
WORK_DIR="${BASE_DIR}/3 DJCU WorkDir"
SYNC_DIR="${BASE_DIR}/Root/Sync_Traktor"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
$DELETE_WORK_FILES && rm "$WORK_DIR"/*.{xml,nml,txt}     || true

WIN_TK_COLLECTION="${SYNC_DIR}/Traktor Config/4_Configuration_Dir/collection.nml"
WIN_RB_COLLECTION="${SYNC_DIR}/Rekordbox Config/rekordbox XML/rekordbox.xml"

TMP_STEP1="1 win traktor.nml"
TMP_STEP2="2 mac traktor.nml"
TMP_STEP3="3 mac rb.xml"
TMP_STEP4="4 win rb.xml"

MAC_TK_COLLECTION="/Users/pedro/Documents/Native Instruments/Traktor 2.11.2/collection.nml"
MAC_RB_COLLECTION="/Users/pedro/Library/Pioneer/rekordbox/rekordbox.xml"


TRAKTOR_TO_REKORDBOX=1
REKORDBOX_TO_TRAKTOR=2

DIRECTION="${TRAKTOR_TO_REKORDBOX}"

function echo_pause()
{
	set +x
	ARGS="$@"
	echo "$ARGS"
	read
	set -x
}


case $DIRECTION in
$TRAKTOR_TO_REKORDBOX)
	## WIN SIDE
	cp -f "${WIN_TK_COLLECTION}" "${TMP_STEP1}"
	cat "$TMP_STEP1" | sed 's| VOLUME="C:" | VOLUME="NFS_share_MacOS" |g'     > "$TMP_STEP2"

	## MAC SIDE
	cp -f "${TMP_STEP2}" "${MAC_TK_COLLECTION}"
	
	echo_pause "Please run REKORDBUDDY2.1 beta 540"
	echo_pause "  IMPORT _FROM_ Traktor"
	echo_pause "  EXPORT _TO_ Rekordbox "

	
	cp -f "${MAC_RB_COLLECTION}" "${TMP_STEP3}"

	## WIN SIDE
	cat "$TMP_STEP3" | sed 's|localhost/Volumes/NFS_share_MacOS|localhost/C:|g' > "$TMP_STEP4"
	cp -f "${TMP_STEP4}" "${WIN_RB_COLLECTION}"
	
	
	echo_pause "import rekordbox.XML is now ready: $WIN_RB_COLLECTION"
	
	;;
	
$REKORDBOX_TO_TRAKTOR)
	## WIN SIDE
	cp -f "${WIN_RB_COLLECTION}" "${TMP_STEP4}"
	cat "$TMP_STEP4" | sed 's|localhost/C:|localhost/Volumes/NFS_share_MacOS|g' > "$TMP_STEP3"

	## MAC SIDE
	cp -f "${TMP_STEP3}" "${MAC_RB_COLLECTION}"
	
	set +x
	echo "Please run REKORDBUDDY2.1 beta 540"
	echo "  IMPORT from rekordbox -> EXPORT to Traktor  "
	read
	set -x
	
	cp -f "${MAC_TK_COLLECTION}" "${TMP_STEP2}"

	## WIN SIDE
	cat "$TMP_STEP2" | sed 's| VOLUME="NFS_share_MacOS" | VOLUME="C:" |g'     > "$TMP_STEP1"
	cp -f "${TMP_STEP1}" "${WIN_TK_COLLECTION}"
	
	;;

*)
	echo "Unk direction"
	exit 1
	;;
esac

	
exit 0



# Extra notes:
#   sed command uses "|". This is to not mix it with "/" 
#   gate playback: Preferences / Advanced / Others / HOT CUE/ During Pause, GATE playback is applied.
