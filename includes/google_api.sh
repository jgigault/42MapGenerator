#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  declare GOOGLE_API_KEY="AIzaSyAO_R8YeQL6Zgl1d-E_H3Y9h3ZF_yZ9meI"

  function main_google_api
  {
    local ADDRESSTYPE="${1}"
    main_google_api_menu
  }

  function main_google_api_menu
  {
    local PREVIEWLINK
    MAPS_ID=0
    MAPS_FORMAT=""
    MAPS[0]=$(utils_get_config "custom_${ADDRESSTYPE}_TITLE")
    if [ "${MAPS[0]}" != "" ]
    then
      MAPS[1]="CUSTOM_$(echo "${ADDRESSTYPE}_${MAPS[0]}" | awk '{gsub(/ /, "_"); print toupper($0)}')"
      MAPS[4]=$(utils_get_config "custom_${ADDRESSTYPE}_NORTH")
      MAPS[5]=$(utils_get_config "custom_${ADDRESSTYPE}_EAST")
      MAPS[6]=$(utils_get_config "custom_${ADDRESSTYPE}_SOUTH")
      MAPS[7]=$(utils_get_config "custom_${ADDRESSTYPE}_WEST")
      PREVIEWLINK="http://www.marine-geo.org/tools/gmrt_image_1.php?maptool=1\&north=$(utils_maps_get_coor "NORTH" "${MAPS_ID}")\&west=$(utils_maps_get_coor "WEST" "${MAPS_ID}")\&east=$(utils_maps_get_coor "EAST" "${MAPS_ID}")\&south=$(utils_maps_get_coor "SOUTH" "${MAPS_ID}")\&mask=0"
      display_header
      display_section
      display_menu\
        "" ""\
        "google_api_generate" "Generate map"\
        "google_api_search" "Change ${ADDRESSTYPE}"\
        "_"\
        "open ${PREVIEWLINK}" "Get a preview image on MGDS portal"\
        "_"\
        "${RETURNFUNCTION}" "CANCEL"
    else
      google_api_search
      if [ "$?" == "0" ]
      then
        echo "0"
        seep 10
        utils_exit
      else
        echo "error"
        seep 10
        utils_exit
      fi
    fi
  }

  function google_api_generate
  {
    MAPS_FORMAT=""
    display_header
    display_section
    display_menu_format
  }

  function google_api_search
  {
    local TITLE="" TITLEURL MSG JSON0 JSON1 STATUS=""
    MAPS[0]=""
    utils_save_config "custom_${ADDRESSTYPE}_TITLE" ""
    while [ "${MAPS[0]}" == "" ]
    do
      display_header
      display_section
      printf "  %s\n\n" "Note: Keep empty and press ENTER to cancel"
      if [ "${STATUS}" != "" ]
      then
        case "${STATUS}" in
          "ZERO_RESULTS")
            MSG="Your query returned no results"
            ;;
          "OVER_QUERY_LIMIT")
            MSG="The daily quota of 2500 queries was reached"
            ;;
          "REQUEST_DENIED")
            MSG="Request denied"
            ;;
          "INVALID_REQUEST")
            MSG="Your request is invalid"
            ;;
          "UNKNOWN_ERROR")
            MSG="An error occured (unknown error)"
            ;;
          *)
            MSG="Unknown error (Status code: ${STATUS})"
            ;;
        esac
        display_error "${MSG}"
        printf "\n"
      fi
      printf "${C_WHITE}"
      tput cnorm
      read -p "  Type a ${ADDRESSTYPE} name: " -e TITLE
      tput civis
      printf "${C_CLEAR}"
      if [ "${TITLE}" == "" ]
      then
        eval "${RETURNFUNCTION}"
      else
        TITLEURL=`echo "${TITLE}" | sed 's/ /+/g'`
        display_header
        display_section
        printf "${C_BLUE}  %s\n\n" "Looking for coordinates..."
        sleep 0.3
        (curl -s "https://maps.googleapis.com/maps/api/geocode/json?components=${ADDRESSTYPE}:${TITLEURL}&key=${GOOGLE_API_KEY}" > .myret 2>&1) &
        display_spinner $!
        STATUS=`cat .myret | sed 's/[" ,]//g' | grep "status" | cut -d: -f2 | sed 's/[ \t]*//g'`
        if [ "${STATUS}" == "OK" ]
        then
          TITLE=`cat .myret | sed 's/[",]//g' | awk 'BEGIN {FS=":"} $0 ~/formatted_address/ {print $2; exit}' | sed 's/^[ ]*//g' | sed 's/[ ]*$//g'`
          JSON0=`awk 'BEGIN {COUNT=0} {print} $0 ~ /address_components/ {COUNT+=1; if (COUNT==2) {exit}}' .myret | sed 's/[" ,]//g'`
          JSON1=`echo "${JSON0}" | awk 'BEGIN {OFS=""; VIEWPORT=0; NORTHEAST=0; SOUTHWEST=0 } $0 ~ /viewport/ {VIEWPORT=1} $0 ~ /northeast/ {if (VIEWPORT==1 && NORTHEAST==0) { NORTHEAST=1 }} $0 ~ /lat/ {if (NORTHEAST>0) {printf "NE" $0 "\n"; NORTHEAST+=1}} $0 ~ /lng/ {if (NORTHEAST>0) {printf "NE" $0 "\n"; NORTHEAST+=1}} $0 ~ /southwest/ {if (VIEWPORT==1 && SOUTHWEST==0) { SOUTHWEST=1 }} $0 ~ /lat/ {if (SOUTHWEST>0) {printf "SW" $0 "\n"; SOUTHWEST+=1}} $0 ~ /lng/ {if (SOUTHWEST>0) {printf "SW" $0 "\n"; SOUTHWEST+=1}} {if (NORTHEAST==3) {NORTHEAST=-1} if(SOUTHWEST==3) {SOUTHWEST=-1}}'`
          utils_save_config "custom_${ADDRESSTYPE}_WEST" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "SWlng" | cut -d":" -f2)")"
          utils_save_config "custom_${ADDRESSTYPE}_EAST" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "NElng" | cut -d":" -f2)")"
          utils_save_config "custom_${ADDRESSTYPE}_SOUTH" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "SWlat" | cut -d":" -f2)")"
          utils_save_config "custom_${ADDRESSTYPE}_NORTH" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "NElat" | cut -d":" -f2)")"
          utils_save_config "custom_${ADDRESSTYPE}_TITLE" "${TITLE}"
          MAPS[0]="${TITLE}"
        fi
      fi
    done
    main_google_api_menu
  }

fi
