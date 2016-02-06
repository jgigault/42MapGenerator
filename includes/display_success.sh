#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_success
  {
    printf "${C_GREEN}  %s\n" "$1"
  }

fi
