#!/bin/bash

cd ${0%/*}/..

. ./scripts/common.sh

###############################################################################
printHeader

echo -e "$(echowhite 'List LV Snapshots') \n"

getParams "$@"

if [[ -z "$prefix" ]]; then
  prefix="SNAP"
fi

if [[ -n $selected_origin ]]; then
  lvs -olv_name,vg_name,lv_size,origin,lv_time -S "origin = $selected_origin"
else
  lvs -olv_name,vg_name,lv_size,origin,lv_time -S "lv_name =~ ^${prefix}_"
fi

completed
