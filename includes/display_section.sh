#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_section
  {
    if [ "${MY_EXPORT_PATH}" != "" ]
    then
      printf "${C_GREY}  Export directory:   ${C_WHITE}$(echo "${MY_EXPORT_PATH}" | sed "s/^$(echo "${HOME}" | sed 's/\//\\\//g')/~/")\n"
      if [ "${DATA_PROVIDER_ID}" != "" ]
      then
        printf "${C_GREY}  Data provider:      ${C_WHITE}${DATA_PROVIDERS[${DATA_PROVIDER_ID}]}\n"
        if [ "${MAPS_ID}" != "" -a "$(utils_maps_get_name "${MAPS_ID}")" != "" ]
        then
          printf "${C_GREY}  Region to export:   ${C_WHITE}$(utils_maps_get_name "${MAPS_ID}")\n"
          if [ "$(utils_maps_get_coor "NORTH" "${MAPS_ID}")" != "" ]
          then
            printf "${C_GREY}  Coordinates:        ${C_WHITE}North:$(utils_maps_get_coor "NORTH" "${MAPS_ID}") East:$(utils_maps_get_coor "EAST" "${MAPS_ID}") South:$(utils_maps_get_coor "SOUTH" "${MAPS_ID}") West:$(utils_maps_get_coor "WEST" "${MAPS_ID}")\n"
          fi
          if [ "${MAPS_FORMAT}" != "" ]
          then
            printf "${C_GREY}  Format:             ${C_WHITE}${MAPS_FORMAT}\n"
            if [ "${OCEAN_TOPOGRAPHY}" != "" ]
            then
              case "${OCEAN_TOPOGRAPHY}" in
                "unavailable")
                  printf "${C_GREY}  Marine topography:  ${C_WHITE}Unavailable\n"; ;;
                "yes")
                  printf "${C_GREY}  Marine topography:  ${C_WHITE}Keep data\n"; ;;
                "no")
                  printf "${C_GREY}  Marine topography:  ${C_WHITE}Flatten ocean\n"; ;;
              esac
              if [ "${MY_EXPORT_PATH_FILENAME}" != "" ]
              then
                printf "${C_GREY}  Export file:        ${C_WHITE}${MY_EXPORT_PATH_FILENAME}\n"
              fi
            fi
          fi
        fi
      fi
      printf "${C_CLEAR}"
      printf "\n"
    fi
  }

fi
