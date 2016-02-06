#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_righttitle
  {
    local LEN MARGIN
    if [ "$1" != "" ]
    then
      LEN=${#1}
      (( MARGIN= $COLUMNS - $LEN))
      printf "%"$MARGIN"s" " "
      printf "$1\n"
    else
      printf "\n"
    fi
  }

fi
