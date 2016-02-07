#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  declare GOOGLE_API_KEY="AIzaSyAO_R8YeQL6Zgl1d-E_H3Y9h3ZF_yZ9meI"

  function main_google_api
  {
    MAPS_ID=0
    MAPS_FORMAT=""
    MAPS[0]=$(utils_get_config "customTITLE")
    if [ "${MAPS[0]}" != "" ]
    then
      MAPS[1]="CUSTOM_$(echo "${MAPS[0]}" | awk '{gsub(/ /, "_"); print toupper($0)}')"
      MAPS[4]=$(utils_get_config "customNORTH")
      MAPS[5]=$(utils_get_config "customEAST")
      MAPS[6]=$(utils_get_config "customSOUTH")
      MAPS[7]=$(utils_get_config "customWEST")
      display_header
      display_section
      display_menu\
        "" ""\
        "google_api_generate" "Generate map"\
        "google_api_search" "Change country"\
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
    utils_save_config "customTITLE" ""
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
      read -p "  Type a country name (e.g. Spain): " -e TITLE
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
        (curl -s "https://maps.googleapis.com/maps/api/geocode/json?components=country:${TITLEURL}&key=${GOOGLE_API_KEY}" > .myret 2>&1) &
        display_spinner $!
        JSON0=`cat .myret | sed 's/[" ,]//g'`
        STATUS=`echo "${JSON0}" | grep "status" | cut -d: -f2 | sed 's/[ \t]*//g'`
        if [ "${STATUS}" == "OK" ]
        then
          TITLE=`cat .myret | sed 's/[",]//g' | grep "formatted_address" | cut -d":" -f2 | sed 's/^[ ]*//g' | sed 's/[ ]*$//g'`
          JSON1=`echo "${JSON0}" | awk 'BEGIN {OFS=""; VIEWPORT=0; NORTHEAST=0; SOUTHWEST=0 } $0 ~ /viewport/ {VIEWPORT=1} $0 ~ /northeast/ {if (VIEWPORT==1 && NORTHEAST==0) { NORTHEAST=1 }} $0 ~ /lat/ {if (NORTHEAST>0) {printf "NE" $0 "\n"; NORTHEAST+=1}} $0 ~ /lng/ {if (NORTHEAST>0) {printf "NE" $0 "\n"; NORTHEAST+=1}} $0 ~ /southwest/ {if (VIEWPORT==1 && SOUTHWEST==0) { SOUTHWEST=1 }} $0 ~ /lat/ {if (SOUTHWEST>0) {printf "SW" $0 "\n"; SOUTHWEST+=1}} $0 ~ /lng/ {if (SOUTHWEST>0) {printf "SW" $0 "\n"; SOUTHWEST+=1}} {if (NORTHEAST==3) {NORTHEAST=-1} if(SOUTHWEST==3) {SOUTHWEST=-1}}'`
          utils_save_config "customWEST" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "SWlng" | cut -d":" -f2)")"
          utils_save_config "customEAST" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "NElng" | cut -d":" -f2)")"
          utils_save_config "customSOUTH" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "SWlat" | cut -d":" -f2)")"
          utils_save_config "customNORTH" "$(printf "%.4f" "$(printf "%s" "${JSON1}" | grep "NElat" | cut -d":" -f2)")"
          utils_save_config "customTITLE" "${TITLE}"
          MAPS[0]="${TITLE}"
        fi
      fi
    done
    main_google_api
  }

fi
