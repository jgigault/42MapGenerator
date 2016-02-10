#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function main_mgds
  {
    RETURNFUNCTION="main_mgds"
    DATA_PROVIDER_ID=$(utils_data_provider_id "MGDS")
    MAPS_ID=""
    display_header
    display_section
    display_menu\
      "" "Find a country or select a preset region:"\
      "main_google_api country" "Find a country"\
      "main_google_api locality" "Find a city"\
      "_"\
      "MAPS" "MAPS_MGDS" "main_mgds_preset"\
      "_"\
      "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
      main "BACK TO MAIN MENU"
  }

  function main_mgds_preset
  {
    RETURNFUNCTION="main_mgds $1"
    MAPS_ID=$1
    MAPS_FORMAT=""
    display_header
    display_section
    display_menu_format
  }

fi
