#!/bin/bash

# disable NFS caching: https://support.apple.com/en-us/HT208209
# de novo

set -x
set -e
set -u

# note: sed command uses "|", to not mixup "/" 


DELETE_FILES=true

####
#### WINDOWS SIDE
####

BASE_DIR="/Volumes/NFS_share_MacOS"
WORK_DIR="${BASE_DIR}/3 DJCU WorkDir"
SYNC_DIR="${BASE_DIR}/Root/Sync_Traktor"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
$DELETE_FILES && rm "$WORK_DIR"/*.{xml,nml,txt}     || true


IN_TK_NAME="collection.nml"
IN_RB_NAME="windows rekordbox.xml"

IN_TK_FOLDER="${SYNC_DIR}/Traktor Config/4_Configuration_Dir"
IN_RB_FOLDER="${SYNC_DIR}/Rekordbox Config/rekordbox XML"

IN_TK_FILE="${IN_TK_FOLDER}/${IN_TK_NAME}"
IN_RB_FILE="${IN_RB_FOLDER}/${IN_RB_NAME}"

STEP1="1 win traktor.nml"
STEP2="2 win rekordbox - with Playlists.xml"

STEP3="3 mac traktor.nml"
STEP4="4 mac rekordbox - no Playlists.xml"

cp -f "${IN_RB_FILE}" "${IN_RB_FILE}.saved_uncorrected"    # pure backup

cp -f "${IN_TK_FILE}" "${STEP1}"
cp -f "${IN_RB_FILE}" "${STEP2}"

cat "$STEP1" | sed 's| VOLUME="C:" | VOLUME="NFS_share_MacOS" |g'     > "$STEP3"
cat "$STEP2" | sed 's|localhost/C:|localhost/Volumes/NFS_share_MacOS|g' | awk '/<PLAYLISTS>/{A=1} {if(A==0){ print}}  /<\/PLAYLISTS>/{A=0 } ' > "$STEP4"

####
#### MAC SIDE
####

ATGR_FOLDER="/Users/pedro/Documents/ATGR Production Team"

mkdir -p "$ATGR_FOLDER"
$DELETE_FILES && rm "$ATGR_FOLDER"/*.{xml,nml,plist,txt,xml-Uncorrected}   || true

IN_DJCU="${ATGR_FOLDER}/Traktor collection.nml"
OUT_DJCU="${ATGR_FOLDER}/Rekordbox(DJCU).xml"
STEP5="5 mac converted - from DJCU with shifted cues.xml"
IN_RECU="${ATGR_FOLDER}/Rekordbox (ANALYSED DATA).xml"


cp -f "${STEP3}" "${IN_DJCU}"
cp -f "${STEP4}" "${IN_RECU}"

echo "Please run DJCU"
read

# copy step5 
cp -f "${OUT_DJCU}" "${STEP5}"    # step 5

LOG_DJCU="$( ls -1t "${ATGR_FOLDER}"/*.txt | head -n 1 )"
STEP6="6 Log DJCU.txt"

cat "${LOG_DJCU}" | tr '\r' '\n'  > "${STEP6}"

echo "please run RECU"
read

LOG_RECU="$( ls -1t "${ATGR_FOLDER}"/*.txt | head -n 1 )"
STEP7="7 Log RECU.txt"
STEP8="8 Correction values.txt"

cat "${LOG_RECU}" | tr '\r' '\n'  > "${STEP7}"
cat "${STEP7}" | awk '/Correction value found/{printf("%-15s %s\n", $4, A) } {A=$0} ' > "${STEP8}"

STEP9="9 mac converted - from RECU with good cues.xml"
STEP10="10 win converted - final.xml"

cp -f "$OUT_DJCU" "$STEP9"
cat "$STEP9" | sed 's|localhost/Volumes/NFS_share_MacOS|localhost/C:|g' > "$STEP10"


IN_RB_NAME="windows rekordbox.xml"

IN_TK_FOLDER="${SYNC_DIR}/Traktor Config/4_Configuration_Dir"
IN_RB_FOLDER="${SYNC_DIR}/Rekordbox Config/rekordbox XML"
cp -f "${STEP10}" "${IN_RB_FILE}"

exit 0
