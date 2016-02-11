#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_menu_format
  {
    local FILENAME="$(utils_maps_get_filename "${MAPS_ID}")" PREVIEWLINK
    if [ "$(utils_maps_get_coor "NORTH" "${MAPS_ID}")" != "" ]
    then
      PREVIEWLINK="http://www.marine-geo.org/tools/gmrt_image_1.php?maptool=1\&north=$(utils_maps_get_coor "NORTH" "${MAPS_ID}")\&west=$(utils_maps_get_coor "WEST" "${MAPS_ID}")\&east=$(utils_maps_get_coor "EAST" "${MAPS_ID}")\&south=$(utils_maps_get_coor "SOUTH" "${MAPS_ID}")\&mask=0"
      display_menu\
        "" "Select a format:"\
        "select_map_format XXL" "XXL (original data)"\
        "select_map_format XL" "XL  (reduce factor: 2)"\
        "select_map_format L" "L   (reduce factor: 4)"\
        "select_map_format M" "M   (reduce factor: 8)"\
        "select_map_format S" "S   (reduce factor: 16)"\
        "_"\
        "open ${PREVIEWLINK}" "Get a preview image on MGDS portal"\
        "_"\
        "${RETURNFUNCTION}" "CANCEL"
    else
      display_menu\
        "" "Select a format:"\
        "select_map_format XXL" "XXL (original data)"\
        "select_map_format XL" "XL (reduce factor: 2)"\
        "select_map_format L" "L (reduce factor: 4)"\
        "select_map_format M" "M (reduce factor: 8)"\
        "select_map_format S" "S (reduce factor: 16)"\
        "_"\
        "${RETURNFUNCTION}" "CANCEL"
    fi
  }

  function select_map_format
  {
    local DOWNLOAD_STATUS=0 OCEAN_TOPOGRAPHY=""
    MAPS_FORMAT=$1
    if [ "${DATA_PROVIDERS[$((${DATA_PROVIDER_ID} + 3))]}" == "ocean_topography_unavailable" ]
    then
      set_ocean_topography "unavailable"
    else
      display_header
      display_section
      display_menu\
        "" "Configure ocean topography:"\
        "set_ocean_topography yes" "Keep data"\
        "set_ocean_topography no" "Flatten ocean"\
        "_"\
        "${RETURNFUNCTION}" "CANCEL"
    fi
  }

  function set_ocean_topography
  {
    local MY_EXPORT_PATH_FILENAME
    OCEAN_TOPOGRAPHY="$1"
    case "${MAPS[$((${MAPS_ID} + 2))]}" in
      "download_and_extract_zip")
        download_map_and_extract_zip
        DOWNLOAD_STATUS=$?
        ;;
      "download_with_mapbox")
        download_map_with_mapbox
        DOWNLOAD_STATUS=$?
        ;;
    esac
    if [ "${DOWNLOAD_STATUS}" == "0" ]
    then
      MY_EXPORT_PATH_FILENAME="$(utils_data_provider_get_abbr "${DATA_PROVIDER_ID}")_${MAPS[$((${MAPS_ID} + 1))]}_$(if [ "${OCEAN_TOPOGRAPHY}" == "yes" ]; then printf "OCEAN1"; else  printf "OCEAN0"; fi)_${MAPS_FORMAT}.fdf"
      if [ ! -f "${MY_EXPORT_PATH}/${MY_EXPORT_PATH_FILENAME}" ]
      then
        generate_map
      else
        display_header
        display_section
        display_menu\
          "" "Export file already exists:"\
          "generate_map" "ERASE"\
          "${RETURNFUNCTION}" "CANCEL"
      fi
    fi
  }

  function generate_map
  {
    local REDUCE_XY_FACTOR=1 REDUCE_Z_FACTOR=1 OCEAN_Z=-10 UNKNOWN_Z=-10 EXPORTED_NROWS EXPORTED_NCOLS EXPORTED_FILESIZE
    case "${MAPS_FORMAT}" in
      "XL")
        REDUCE_XY_FACTOR=2
        REDUCE_Z_FACTOR=2
        OCEAN_Z=-5
        UNKNOWN_Z=-5
        ;;
      "L")
        REDUCE_XY_FACTOR=4
        REDUCE_Z_FACTOR=4
        OCEAN_Z=-3
        UNKNOWN_Z=-3
        ;;
      "M")
        REDUCE_XY_FACTOR=8
        REDUCE_Z_FACTOR=8
        OCEAN_Z=-2
        UNKNOWN_Z=-2
        ;;
      "S")
        REDUCE_XY_FACTOR=16
        REDUCE_Z_FACTOR=16
        OCEAN_Z=-1
        UNKNOWN_Z=-1
        ;;
    esac
    display_header
    display_section
    printf "${C_BLUE}  %s\n\n" "Computing data..."
    (awk\
      -v REDUCE_XY_FACTOR="${REDUCE_XY_FACTOR}"\
      -v REDUCE_Z_FACTOR="${REDUCE_Z_FACTOR}"\
      -v UNKNOWN_Z="${UNKNOWN_Z}"\
      -v OCEAN_Z="${OCEAN_Z}"\
      -v OCEAN_TOPOGRAPHY="${OCEAN_TOPOGRAPHY}"\
      'BEGIN {odd=0}\
      {\
        odd+=1;\
        if(odd==1)\
        {\
          for(i=1;i<=NF;i++)\
          {\
            if(OCEAN_TOPOGRAPHY=="unavailable" && $i==-9999)\
            {\
              printf UNKNOWN_Z\
            }\
            else\
            {\
              if(OCEAN_TOPOGRAPHY!="yes" && $i<0)\
              {\
                printf OCEAN_Z\
              }\
              else\
              {\
                printf("%d", $i/REDUCE_Z_FACTOR)\
              }\
            }\
            i+=REDUCE_XY_FACTOR;\
            if(i>=NF)\
            {\
              printf "\n"\
            }\
            else\
            {\
              printf " "\
            }\
          }\
        }\
        if(odd==REDUCE_XY_FACTOR)\
        {\
          odd=0\
        }\
      }'\
      "${MAPS_TMPDIR}$(utils_data_provider_get_abbr "${DATA_PROVIDER_ID}")_${FILENAME}.txt" > "${MY_EXPORT_PATH}/${MY_EXPORT_PATH_FILENAME}"\
    ) &
    display_spinner $!
    display_header
    display_section
    if [ -f "${MY_EXPORT_PATH}/${MY_EXPORT_PATH_FILENAME}" ]
    then
      EXPORTED_NROWS="$(awk 'BEGIN{OFS=""; ORS=""; TOTAL=0} NF > 2 {TOTAL+=1} END {print TOTAL/1}' "${MY_EXPORT_PATH}/${MY_EXPORT_PATH_FILENAME}")"
      EXPORTED_NCOLS="$(awk 'BEGIN{OFS=""; ORS=""} NF > 2 {print NF/1; exit}' "${MY_EXPORT_PATH}/${MY_EXPORT_PATH_FILENAME}")"
      EXPORTED_FILESIZE="$(du -k -h "${MY_EXPORT_PATH}/${MY_EXPORT_PATH_FILENAME}" | cut -f 1)"
      display_success "Export was successful!"
      display_success "Map size:  ${EXPORTED_NCOLS} x ${EXPORTED_NROWS} (width x height)"
      display_success "File size: ${EXPORTED_FILESIZE}"
    else
      display_error "An error occured, no file exported"
    fi
    printf "\n"
    display_menu\
      "" ""\
      "${RETURNFUNCTION}" "OK"
  }

fi
