#!/bin/bash

cd ${0%/*}/..

. ./scripts/common.sh

###############################################################################
printHeader

echo -e "$(echowhite 'Create Snapshot') \n"

hasArgs=false
usage="$(basename "$0") [--target|-t] Target of the lv eg. volgroup/lvname \n \
         [--size|-s]   Size of the snapshot \n \
         [--prefix|-p] (optional) override prefix snapshot name, defaults to SNAP \n \
         [--debug]     Sets -x flag for debug output"

getParams "$@"

if [[ $hasArgs != true ]]; then
  # Choose an LV
  showLVSelection selected_lv

  # LV size in MB
  selected_lv_size="$(lvs -olv_size --noheadings --nosuffix --units m $selected_lv)"
  selected_lv_size=${selected_lv_size%.*}

  # Enter snapshot size
  text=$(echowhite "${CONST_ENTER_SNAPSHOT_SIZE}")
  read -r -p " $text" response
  response=${response,,}

  if [[ -z "$response" ]]; then
    echo -e "${CONST_USING_DEFAULT}\n"
  else
    selected_lv_size=${response%.*}
  fi
elif [[ -z $selected_lv ]]; then
  # Check we have all args TODO: should be fixed with getoptex()
  echoerror "Missing <target> parameter."
elif [[ -z $selected_lv_size ]]; then
  # Check we have all args TODO: should be fixed with getoptex()
  echoerror "Missing <size> parameter."
fi

if [[ -z "$prefix" ]]; then
  prefix="SNAP"
fi

# LV snapshot name

lv_snapname="${prefix}_`basename $selected_lv`_`date +"%Y-%m-%d_%H%M%S"`"
echo -e "${CONST_SIZE} ${selected_lv_size}MB\n"
echo "${CONST_CREATING_SNAPSHOT} ${lv_snapname}..."

doit lvcreate --size ${selected_lv_size}M --snapshot -n"$lv_snapname" "$selected_lv"
if [ $? -ne 0 ]; then
  exit 1
fi

completed
