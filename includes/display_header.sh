#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_header
  {
    local MARGIN
    utils_clear
    utils_set_env
    if [ "$1" != "" ]
    then
      printf "$1"
    else
      printf ${C_INVERT}""
    fi
    display_righttitle "PRESS ESCAPE TO EXIT - V2.r${CVERSION}"
    display_center "  _  _  ____  __  __              ____             "
    display_center " | || ||___ \|  \/  | __ _ _ __  / ___| ___ _ __   "
    display_center " | || |_ __) | |\/| |/ _\ | '_ \| |  _ / _ \ '_ \  "
    display_center " |__   _/ __/| |  | | (_| | |_) | |_| |  __/ | | | "
    display_center "    |_||_____|_|  |_|\__,_| .__/ \____|\___|_| |_| "
    display_center " jgigault @ student.42.fr |_|       06 51 15 98 82 "
    display_center " "
    printf "${C_CLEAR}\n\n"
  }

fi
