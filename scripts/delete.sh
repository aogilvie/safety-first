#!/bin/bash

cd ${0%/*}/..

. ./scripts/common.sh

###############################################################################
printHeader

echo -e "$(echowhite 'Delete Snapshot') \n"

hasArgs=false
usage="$(basename "$0") [--name|-n]    Name of the lv snapshot eg. volgroup/lvname \n \
         [--history|-h] Delete all history of snapshots before date \n \
         [--debug]      Sets -x flag for debug output"

getParams "$@"

if [[ $hasArgs != true ]]; then
  # Choose an LV
  showLVSelection selected_snapshot
fi

function batchRemove {
  if [[ "${@}" == "" ]]; then
    # Nothing to delete
    echo "Nothing to delete."
    return
  fi
  for lv in "${@}"
  do
  lvremove -f "/dev/$lv"
  done
}

if [[ -n $before_date ]]; then
  # Delete snapshots before date specified
  lvs=$(lvs -ovg_name,lv_name -S "lv_name =~ SNAP && lv_time < '${before_date}'" --noheadings --separator "/")
  batchRemove $lvs
elif [[ -n $selected_snapshot ]]; then
  # Delete specific snapshot
  lvremove -f "/dev/$selected_snapshot"
fi

completed
