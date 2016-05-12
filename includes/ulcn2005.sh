#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function main_ulcn2005
  {
    RETURNFUNCTION="main_ulcn2005"
    DATA_PROVIDER_ID=$(utils_data_provider_id "ULCN2005")
    MAPS_ID=""
    display_header
    display_section
    display_menu\
      "" "Select a preset region:"\
      "MAPS" "MAPS_ULCN2005" "main_ulcn2005_preset"\
      "_"\
      "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
      main "BACK TO MAIN MENU"
  }

  function main_ulcn2005_preset
  {
    RETURNFUNCTION="main_ulcn2005 $1"
    MAPS_ID=$1
    MAPS_FORMAT=""
    display_header
    display_section
    display_menu_format
  }

fi
