#!/bin/bash

#####################################################
#  _  _  ____  __  __              ____             #
# | || ||___ \|  \/  | __ _ _ __  / ___| ___ _ __   #
# | || |_ __) | |\/| |/ _` | '_ \| |  _ / _ \ '_ \  #
# |__   _/ __/| |  | | (_| | |_) | |_| |  __/ | | | #
#    |_||_____|_|  |_|\__,_| .__/ \____|\___|_| |_| #
# jgigault @ student.42.fr |_|       06 51 15 98 82 #
#####################################################

OPT_NO_UPDATE=0
OPT_NO_COLOR=0
OPT_NO_TIMEOUT=0
OPT_WITH_ENTRYPATH=0

i=1
while (( i <= $# ))
do
  case "${!i}" in
    "--no-update") OPT_NO_UPDATE=1 ;;
    "--no-color") OPT_NO_COLOR=1 ;;
    "--no-timeout") OPT_NO_TIMEOUT=1 ;;
    "--with-entrypath")
      OPT_WITH_ENTRYPATH=1
      (( i += 1 ))
      GLOBAL_ENTRYPATH="${!i}"
      ;;
  esac
  (( i += 1 ))
done

function mapgen_install_dir
{
  local SOURCE="${BASH_SOURCE[0]}"
  local DIR
  while [ -h "${SOURCE}" ]
  do
    DIR="$(cd -P "$(dirname "${SOURCE}")" && pwd)"
    SOURCE="$(readlink "${SOURCE}")"
    [[ "${SOURCE}" != /* ]] && SOURCE="${DIR}/${SOURCE}"
  done
  printf "%s" "$(cd -P "$(dirname "${SOURCE}")" && pwd)"
}

if [ "${OPT_WITH_ENTRYPATH}" == "0" -o "${GLOBAL_ENTRYPATH}" == "" ]
then
  GLOBAL_ENTRYPATH=$(pwd)
fi
GLOBAL_INSTALLDIR=$(mapgen_install_dir)
cd "${GLOBAL_INSTALLDIR}"

MAPGENERATOR_SH=1
RETURNPATH=$(pwd | sed 's/ /\ /g')
CVERSION=$(git log --oneline 2>/dev/null | awk 'END {printf NR}' | sed 's/ //g')
if [ "$CVERSION" == "" ]; then CVERSION="???"; fi


source includes/maps.sh
source includes/data_providers.sh
source includes/utils.sh
source includes/display_menu.sh
source includes/display_header.sh
source includes/display_center.sh
source includes/display_section.sh
source includes/display_error.sh
source includes/display_success.sh
source includes/display_right.sh
source includes/display_spinner.sh
source includes/generate_map.sh
source includes/download_map.sh
source includes/google_api.sh
source includes/ign.sh
source includes/noaa.sh
source includes/mgds.sh
source includes/usgs.sh
source includes/config.sh
source includes/credits.sh
source includes/update.sh
source includes/signals.sh


function main
{
  local RETURNFUNCTION="main" DATA_PROVIDER_ID="" MAPS_ID="" MAPS_FORMAT="" MY_EXPORT_PATH=$(utils_get_config "export_path")
  if [ "${MY_EXPORT_PATH}" == "" ]
  then
    config_path
  else
    display_header
    display_section
    display_menu\
      "" "Select a data provider:"\
      main_ign "${DATA_PROVIDERS[$(utils_data_provider_id "IGN")]}"\
      main_noaa "${DATA_PROVIDERS[$(utils_data_provider_id "NOAA")]}"\
      main_mgds "${DATA_PROVIDERS[$(utils_data_provider_id "MGDS")]}"\
      main_usgs "${DATA_PROVIDERS[$(utils_data_provider_id "USGS")]}"\
      "_"\
      "config_path" "Change export directory"\
      "_"\
      "utils_option_set OPT_NO_TIMEOUT" "$(if [ "$OPT_NO_TIMEOUT" == 0 ]; then echo "Disable timeout      (--no-timeout)"; else echo "Enable timeout"; fi)"\
      "utils_option_set OPT_NO_COLOR" "$(if [ "$OPT_NO_COLOR" == 0 ]; then echo "Disable color        (--no-color)"; else echo "Enable color"; fi)"\
      "_"\
      display_credits "CREDITS"\
      "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
      utils_exit "EXIT"
  fi
}

utils_start
