#!/bin/bash

cd ${0%/*}/..

. ./scripts/common.sh

###############################################################################
printHeader

echo -e "$(echowhite 'Restore Snapshot') \n"

hasArgs=false
usage="$(basename "$0") [--name|-n] Snapshot name eg. volgroup/SNAP_1234567_test \n \
          [--debug]   Sets -x flag for debug output"

getParams "$@"

if [[ $hasArgs != true ]]; then
  # Choose an LV
  showLVSelection selected_snapshot
fi

# Create new backup
targetArr=( $(lvs -ovg_name,origin,lv_size --noheadings --nosuffix --units m $selected_snapshot) )
if [[ ${#targetArr[@]} == 0 ]]; then
  echoerror "No snapshot found."
fi

targetSnapshot=$selected_snapshot
backupResult=$( ./scripts/backup.sh --target "${targetArr[0]}/${targetArr[1]}" --size "${targetArr[2]}" 2>&1 > /dev/null )

if [[ $? != 0 ]]; then
  echoerror "$backupResult"
fi

echook "Success backup"

# Deactivate lv
doit lvchange -an -y $targetSnapshot

echook "Deactivated $targetSnapshot"

# Merge the snapshot into origin
doit lvconvert --merge $targetSnapshot

echook "Merged $targetSnapshot"

# Activate lv origin
doit lvchange -ay -y ${targetArr[0]}/${targetArr[1]}

echook "Activated all LVs from origin ${targetArr[0]}/${targetArr[1]}"

completed
