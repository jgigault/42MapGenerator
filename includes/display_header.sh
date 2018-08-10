#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_header
  {
    local MARGIN COLOR

    utils_clear
    utils_set_env
    COLOR=${1}
    if [ -z "${COLOR}" ]
    then
      COLOR="${C_INVERTGREY}"
    fi
    if [ "${GLOBAL_LOCALBRANCH}" != "master" ]
    then
      display_leftandright "${COLOR}" "${COLOR}" "${COLOR}" "DEVELOPMENT MODE" "${GLOBAL_LOCALBRANCH}"
    else
      if [ "${GLOBAL_DISK_USAGE}" -gt "100" ]
      then
        display_leftandright "${C_INVERTGREY}" "${COLOR}" "${COLOR}" "DISK USAGE: ${GLOBAL_DISK_USAGE}M" "PRESS ESCAPE TO EXIT - V${GLOBAL_VERSION}.r${GLOBAL_CVERSION}"
      else
        display_leftandright "${COLOR}" "${COLOR}" "${COLOR}" "DISK USAGE: ${GLOBAL_DISK_USAGE}M" "PRESS ESCAPE TO EXIT - V${GLOBAL_VERSION}.r${GLOBAL_CVERSION}"
      fi
    fi
    display_center "  _  _  ____  __  __              ____             "
    display_center " | || ||___ \|  \/  | __ _ _ __  / ___| ___ _ __   "
    display_center " | || |_ __) | |\/| |/ _\ | '_ \| |  _ / _ \ '_ \  "
    display_center " |__   _/ __/| |  | | (_| | |_) | |_| |  __/ | | | "
    display_center "    |_||_____|_|  |_|\__,_| .__/ \____|\___|_| |_| "
    display_center "                          |_|                      "
    printf "${C_CLEAR}\n"
  }

fi
