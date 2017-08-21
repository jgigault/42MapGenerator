#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function download_map_and_extract_zip
  {
    local TMPFILENAME="$(utils_data_provider_get_abbr "${DATA_PROVIDER_ID}")_${FILENAME}.txt" TMPDOWNLOADLINK
    if [ ! -f "${MAPS_TMPDIR}${TMPFILENAME}" ]
    then
      [ "${DOWNLOADLINK}" == "" ] && TMPDOWNLOADLINK="$(utils_data_provider_get_url "${DATA_PROVIDER_ID}")${FILENAME}.zip" || TMPDOWNLOADLINK="${DOWNLOADLINK}"
      download_map "${TMPFILENAME}.zip" "${TMPDOWNLOADLINK}" && extract_map "${TMPFILENAME}.zip" "${TMPFILENAME}" "${ARCHIVE_FILENAME}" && check_headers "${TMPFILENAME}"
      return "$?"
    else
      return 0
    fi
  }

  function download_map_and_extract_gz
  {
    local TMPFILENAME="$(utils_data_provider_get_abbr "${DATA_PROVIDER_ID}")_${FILENAME}.txt" TMPDOWNLOADLINK
    if [ ! -f "${MAPS_TMPDIR}${TMPFILENAME}" ]
    then
      [ "${DOWNLOADLINK}" == "" ] && TMPDOWNLOADLINK="$(utils_data_provider_get_url "${DATA_PROVIDER_ID}")${FILENAME}.zip" || TMPDOWNLOADLINK="${DOWNLOADLINK}"
      download_map "${TMPFILENAME}.gz" "${TMPDOWNLOADLINK}" && extract_map "${TMPFILENAME}.gz" "${TMPFILENAME}" "${ARCHIVE_FILENAME}" && check_headers "${TMPFILENAME}"
      return "$?"
    else
      return 0
    fi
  }

  function download_map_with_mapbox
  {
    local TMPFILENAME="$(utils_data_provider_get_abbr "${DATA_PROVIDER_ID}")_${FILENAME}.txt" URL_REQUEST="$(utils_data_provider_get_url "${DATA_PROVIDER_ID}")" NORTH=$(utils_maps_get_coor "NORTH" "${MAPS_ID}") EAST=$(utils_maps_get_coor "EAST" "${MAPS_ID}") SOUTH=$(utils_maps_get_coor "SOUTH" "${MAPS_ID}") WEST=$(utils_maps_get_coor "WEST" "${MAPS_ID}")
    URL_REQUEST=${URL_REQUEST/MAPGEN_MAPBOX/"${WEST},${SOUTH},${EAST},${NORTH}"}
    URL_REQUEST=${URL_REQUEST/MAPGEN_NORTH/${NORTH}}
    URL_REQUEST=${URL_REQUEST/MAPGEN_EAST/${EAST}}
    URL_REQUEST=${URL_REQUEST/MAPGEN_SOUTH/${SOUTH}}
    URL_REQUEST=${URL_REQUEST/MAPGEN_WEST/${WEST}}
    MY_EXPORT_URL="${URL_REQUEST}"
    if [ ! -f "${MAPS_TMPDIR}${TMPFILENAME}" ]
    then
      download_map "${TMPFILENAME}" "${URL_REQUEST}" && check_headers "${TMPFILENAME}"
      return "$?"
    else
      return 0
    fi
  }

  function download_map
  {
    create_tmp_dir
    display_header
    display_section
    printf "${C_BLUE}  %s\n  %s\n\n" "Downloading $1 from remote server..." "$2"
    sleep 0.5
    (curl --show-error --output "${MAPS_TMPDIR}$1" "$2") &
    display_spinner $!
    printf $C_CLEAR""
    if [ ! -f "${MAPS_TMPDIR}$1" -o "$?" != "0" ]
    then
      display_header
      display_section
      display_error "An error occured while downloading file:"
      display_error "$2"
      printf "\n"
      display_menu\
        "" ""\
        "${RETURNFUNCTION}" "OK"\
        "_"\
        "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
        "utils_exit" "EXIT"
      return 1
    else
      printf "\n${C_BLUE}  Completed!\n\n"
      sleep 1
    fi
    return 0
  }

  function extract_map
  {
    local IS_TXTGZ=0 EXTRACTED_FILE="" EXTRACT_DIRECTORY="${MAPS_TMPDIR}extract/"
    display_header
    display_section
    printf "${C_BLUE}  %s\n\n" "Extracting map from archive..."
    sleep 0.5
    rm -rf "${EXTRACT_DIRECTORY}"
    create_tmp_dir "extract/"
    if [[ "${MAPS_TMPDIR}$1" =~ \.txt\.gz ]]
    then
      IS_TXTGZ=1
      (gunzip -c "${MAPS_TMPDIR}$1" > "${MAPS_TMPDIR}$2") &
    else
      if [ "${ARCHIVE_FILENAME}" != "${FILENAME}" ]
      then
        (unzip -o -j -d "${EXTRACT_DIRECTORY}" "${MAPS_TMPDIR}$1" "*${ARCHIVE_FILENAME}") &
      else
        (unzip -o -j -d "${EXTRACT_DIRECTORY}" "${MAPS_TMPDIR}$1" \*.[Aa][Ss][Cc]) &
      fi
    fi
    display_spinner $!
    if [ "$?" != "0" ]
    then
      display_header
      display_section
      display_error "An error occured while extracting file:"
      display_error "${MAPS_TMPDIR}$1"
      printf "\n"
      display_menu\
        "" ""\
        "${RETURNFUNCTION}" "OK"\
        "_"\
        "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
        "utils_exit" "EXIT"
      return 1
    else
      if [ "${ARCHIVE_FILENAME}" != "${FILENAME}" ]
      then
        EXTRACTED_FILE=`find "${EXTRACT_DIRECTORY}/" -name "*${ARCHIVE_FILENAME}" | awk '{if(NR==1) {print}}'`
      else
        [ "${IS_TXTGZ}" == "0" ] && EXTRACTED_FILE=`find "${EXTRACT_DIRECTORY}/" -name \*.[Aa][Ss][Cc] | awk '{if(NR==1) {print}}'`
      fi
      if [ "${EXTRACTED_FILE}" == "" -a "${IS_TXTGZ}" == "0" ]
      then
        display_header
        display_section
        display_error "An error occured while extracting file:"
        display_error "${MAPS_TMPDIR}$1"
        printf "\n"
        display_menu\
          "" ""\
          "${RETURNFUNCTION}" "OK"\
          "_"\
          "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
          "utils_exit" "EXIT"
        return 1
      else
        [ "${IS_TXTGZ}" == "0" ] && mv "${EXTRACTED_FILE}" "${MAPS_TMPDIR}$2"
        rm -f "${MAPS_TMPDIR}$1"
        rm -rf "${MAPS_TMPDIR}extract/"
        printf "\n${C_BLUE}  Completed!\n\n"
        sleep 1
      fi
    fi
    return 0
  }

  function check_headers
  {
    local HEADER_NCOLS HEADER_NROWS REAL_NCOLS REAL_NROWS DIFF_NCOLS DIFF_NROWS
    display_header
    display_section
    printf "${C_BLUE}  %s\n\n" "Checking headers..."
    sleep .3
    HEADER_NCOLS="$(awk 'BEGIN{OFS=""; ORS=""} $1 == "ncols" {print $2/1; exit}' "${MAPS_TMPDIR}$1")"
    HEADER_NROWS="$(awk 'BEGIN{OFS=""; ORS=""} $1 == "nrows" {print $2/1; exit}' "${MAPS_TMPDIR}$1")"
    REAL_NCOLS="$(awk 'BEGIN{OFS=""; ORS=""} NF > 2 {print NF/1; exit}' "${MAPS_TMPDIR}$1")"
    #REAL_NROWS="$(awk 'BEGIN{OFS=""; ORS=""; TOTAL=0} NF > 2 {TOTAL+=1} END {print TOTAL/1}' "${MAPS_TMPDIR}$1")"
    if [ "${HEADER_NCOLS}" == "" ]; then HEADER_NCOLS=0; fi
    if [ "${HEADER_NROWS}" == "" ]; then HEADER_NROWS=0; fi
    if [ "${REAL_NCOLS}" == "" ]; then REAL_NCOLS=0; fi
    #if [ "${REAL_NROWS}" == "" ]; then REAL_NROWS=0; fi
    (( DIFF_NCOLS= "${HEADER_NCOLS}" - "${REAL_NCOLS}" ))
    #(( DIFF_NROWS= "${HEADER_NROWS}" - "${REAL_NROWS}" ))
    if [[ "${HEADER_NCOLS}" -le "0" || "${HEADER_NROWS}" -le "0" || "${DIFF_NCOLS}" -lt -3 || "${DIFF_NCOLS}" -gt 3 ]] # || "${DIFF_NROWS}" -lt -3 || "${DIFF_NROWS}" -gt 3
    then
      rm -f "${MAPS_TMPDIR}$1"
      display_header
      display_section
      display_error "The file downloaded from the remote server is corrupted"
      display_error "Maybe the requested region is too large or is not supported"
      display_error "${MY_EXPORT_URL}"
      printf "\n"
      display_menu\
        "" ""\
        "${RETURNFUNCTION}" "OK"\
        "_"\
        "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
        "utils_exit" "EXIT"
      return 1
    fi
    return 0
  }

fi
