#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function main_usgs
  {
    RETURNFUNCTION="main_usgs"
    DATA_PROVIDER_ID=$(utils_data_provider_id "USGS")
    MAPS_ID=""
    display_header
    display_section
    display_menu\
      "" "Select a preset region:"\
      "MAPS" "MAPS_USGS" "main_usgs_preset"\
      "_"\
      "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
      main "BACK TO MAIN MENU"
  }

  function main_usgs_preset
  {
    RETURNFUNCTION="main_usgs $1"
    MAPS_ID=$1
    MAPS_FORMAT=""
    display_header
    display_section
    display_menu_format
  }

fi
