#!/bin/bash

. ./lib/rainbow/rainbow.sh
. ./lib/getoptx/getoptx.sh
. ./scripts/lang/english.sh

# Print header
function printHeader {
  echo -e "$(echowhite '########################################')"
  echo -e "$(echowhite 'SAFETY FIRST - A tool for LV management')"
  echo -e "$(echowhite '########################################')"
}

# Echo error
# $1: error string to print
function echoerror {
  local echoit=$(echored "☓ ${1}")
  >&2 echo -e "\n $echoit"
  exit 1
}

# Completed something
function echook {
  local echoit=$(echogreen "✓ ${1}")
  echo -e "\n $echoit"
}

# Completed script
function completed {
  local echoit=$(echogreen "✓ Complete")
  echo -e "\n $echoit"
  exit 0
}

# Check run as root
if [[ $EUID -ne 0 ]]; then
   echoerror "This script must be run as root"
   exit 1
fi

# Capture errors easily and format output
# $1: command to run
function doit {
  # Redirect stderr to std out
	output=$($@ 2>&1)
	local status=$?
	if [ $status -ne 0 ]; then
		echoerror "Error $status : $output"
	fi
	return $status
}

# Show a list of lvs for user choice
# $1: returns selected_lv to 1st param
function showLVSelection {
  local lv_list=($(lvs -olv_full_name --noheadings))

  PS3=$(echowhite "${CONST_CHOOSE_A_LV}")
  select opt in "${lv_list[@]}"
  do
    if [ -z "$opt" ]; then
      echoerror "$CONST_BAD_SELECTION"
      exit 1
    fi
    echo -e "\n${CONST_SELECTED} ${opt}"
    eval "$1=$opt"
    break;
  done
}

# Parses CL parameters
function getParams {
  while getoptex "o: origin: h: history: p: prefix: n: name: s: size: t: target: debug; help;" "$@"
  do
   case "$OPTOPT" in
     t|target)
       selected_lv="$OPTARG"
       ;;
     n|name)
       selected_snapshot="$OPTARG"
       ;;
     s|size)
       selected_lv_size="$OPTARG"
       ;;
     h|history)
       before_date="$OPTARG"
       ;;
     p|prefix)
       prefix="$OPTARG"
       ;;
     o|origin)
       selected_origin="$OPTARG"
       ;;
     debug)
       set -x
       ;;
     help)
       echo -e "$usage" >&2
       completed
       ;;
     *)
       echoerror "Bad arguments."
       ;;
   esac
  done

  if [[ $OPTOPT = "?" ]]; then
   exit 1;
  elif [[ -n "$OPTOPT" ]]; then
   hasArgs=true
  fi
}
