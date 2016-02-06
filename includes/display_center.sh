#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_center
  {
    local LEN MARGIN
    if [ "$1" != "" ]
    then
      LEN=${#1}
      (( MARGIN= (${COLUMNS} - ${LEN}) / 2 ))
      printf "%"${MARGIN}"s" " "
      printf "$1"
      (( MARGIN= ${MARGIN} + (${COLUMNS} - ${LEN} - ${MARGIN} * 2) ))
      printf "%"${MARGIN}"s" " "
    else
      printf "\n"
    fi
  }

fi
