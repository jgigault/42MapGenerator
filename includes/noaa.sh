#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function main_noaa
  {
    RETURNFUNCTION="main_noaa"
    DATA_PROVIDER_ID=$(utils_data_provider_id "NOAA")
    MAPS_ID=""
    display_header
    display_section
    display_menu\
      "" "Find a country or select a preset region:"\
      "main_google_api country" "Find a country"\
      "_"\
      "MAPS" "MAPS_NOAA" "main_noaa_preset"\
      "_"\
      "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
      main "BACK TO MAIN MENU"
  }

  function main_noaa_preset
  {
    RETURNFUNCTION="main_noaa $1"
    MAPS_ID=$1
    MAPS_FORMAT=""
    display_header
    display_section
    display_menu_format
  }

fi
