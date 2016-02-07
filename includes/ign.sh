#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function main_ign
  {
    RETURNFUNCTION="main_ign"
    DATA_PROVIDER_ID=$(utils_data_provider_id "IGN")
    MAPS_ID=""
    display_header
    display_section
    display_menu\
      "" "Select a preset region:"\
      "MAPS" "MAPS_IGN" "main_ign_preset"\
      "_"\
      "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
      main "BACK TO MAIN MENU"
  }

  function main_ign_preset
  {
    RETURNFUNCTION="main_ign $1"
    MAPS_ID=$1
    MAPS_FORMAT=""
    display_header
    display_section
    display_menu_format
  }

fi
