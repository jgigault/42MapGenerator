#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  declare -a MAPS
  declare -i MAPS_SHIFT=9
  declare -a MAPS_IGN='(1 2 3 4 5 6)'
  declare -a MAPS_NOAA='(10 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27)'
  declare -a MAPS_MGDS='(7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27)'
  declare -a MAPS_USGS='(28 29)'

  # RESERVED FOR CUSTOM COORDINATES

  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""

  # IGN

  MAPS[${#MAPS[*]}]="France Métropolitaine"
  MAPS[${#MAPS[*]}]="France_250_ASC_L93"
  MAPS[${#MAPS[*]}]="download_and_extract_zip"
  MAPS[${#MAPS[*]}]="12.7M"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="DOM-TOM: Guadeloupe"
  MAPS[${#MAPS[*]}]="Guadeloupe_MNT250_ASC"
  MAPS[${#MAPS[*]}]="download_and_extract_zip"
  MAPS[${#MAPS[*]}]="25K"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="DOM-TOM: Martinique"
  MAPS[${#MAPS[*]}]="Martinique_MNT250_ASC"
  MAPS[${#MAPS[*]}]="download_and_extract_zip"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="DOM-TOM: Réunion"
  MAPS[${#MAPS[*]}]="Reunion_MNT250_ASC"
  MAPS[${#MAPS[*]}]="download_and_extract_zip"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="DOM-TOM: Guyane"
  MAPS[${#MAPS[*]}]="Guyane_MNT250_ASC"
  MAPS[${#MAPS[*]}]="download_and_extract_zip"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="DOM-TOM: Saint Martin - Saint Barthélémy"
  MAPS[${#MAPS[*]}]="ST_MART_ST_BART_MNT250_ASC"
  MAPS[${#MAPS[*]}]="download_and_extract_zip"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""

  # NOAA/MGDS

  MAPS[${#MAPS[*]}]="Whole World"
  MAPS[${#MAPS[*]}]="WHOLE_WORLD"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="81"
  MAPS[${#MAPS[*]}]="180"
  MAPS[${#MAPS[*]}]="-78"
  MAPS[${#MAPS[*]}]="-180"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Antarctic"
  MAPS[${#MAPS[*]}]="ANTARCTIC"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="-60"
  MAPS[${#MAPS[*]}]="180"
  MAPS[${#MAPS[*]}]="-78"
  MAPS[${#MAPS[*]}]="-180"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Arctic"
  MAPS[${#MAPS[*]}]="ARCTIC"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="81"
  MAPS[${#MAPS[*]}]="180"
  MAPS[${#MAPS[*]}]="72"
  MAPS[${#MAPS[*]}]="-180"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Europe"
  MAPS[${#MAPS[*]}]="EUROPE"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="59.0250"
  MAPS[${#MAPS[*]}]="31.6583"
  MAPS[${#MAPS[*]}]="35.5916"
  MAPS[${#MAPS[*]}]="-13.0916"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Alaska-Aleutians"
  MAPS[${#MAPS[*]}]="ALASKA_ALEUTIANS"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="63"
  MAPS[${#MAPS[*]}]="-135"
  MAPS[${#MAPS[*]}]="48"
  MAPS[${#MAPS[*]}]="162"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Cascade Range (West Coast USA)"
  MAPS[${#MAPS[*]}]="CASCADIA_RANGE_WEST_COAST_USA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="52"
  MAPS[${#MAPS[*]}]="-118"
  MAPS[${#MAPS[*]}]="39"
  MAPS[${#MAPS[*]}]="-132"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Central America"
  MAPS[${#MAPS[*]}]="CENTRAL_AMERICA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="17"
  MAPS[${#MAPS[*]}]="-80"
  MAPS[${#MAPS[*]}]="5"
  MAPS[${#MAPS[*]}]="-95"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="East African Rift System"
  MAPS[${#MAPS[*]}]="EAST_AFRICAN_RIFT_SYSTEM"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="17"
  MAPS[${#MAPS[*]}]="45"
  MAPS[${#MAPS[*]}]="-20"
  MAPS[${#MAPS[*]}]="24"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Eastern North American Margin"
  MAPS[${#MAPS[*]}]="EASTERN_NORTH_AMERICAN_MARGIN"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="53"
  MAPS[${#MAPS[*]}]="-42"
  MAPS[${#MAPS[*]}]="28"
  MAPS[${#MAPS[*]}]="-85"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Gulf of California"
  MAPS[${#MAPS[*]}]="GULF_OF_CALIFORNIA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="32"
  MAPS[${#MAPS[*]}]="-108"
  MAPS[${#MAPS[*]}]="22"
  MAPS[${#MAPS[*]}]="-117"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Amazonia"
  MAPS[${#MAPS[*]}]="AMAZONIA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="13.2416"
  MAPS[${#MAPS[*]}]="-33.3583"
  MAPS[${#MAPS[*]}]="-17.9916"
  MAPS[${#MAPS[*]}]="-82.8583"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Cordillera de los Andes"
  MAPS[${#MAPS[*]}]="CORDILLERA_DE_LOS_ANDES"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="13.0416"
  MAPS[${#MAPS[*]}]="-61.8583"
  MAPS[${#MAPS[*]}]="-57.1750"
  MAPS[${#MAPS[*]}]="-82.4416"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Izu-Bonin-Marinia"
  MAPS[${#MAPS[*]}]="IZU_BONIN_MARIANIA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="36"
  MAPS[${#MAPS[*]}]="150"
  MAPS[${#MAPS[*]}]="10"
  MAPS[${#MAPS[*]}]="138"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Nankai"
  MAPS[${#MAPS[*]}]="NANKAI"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="35"
  MAPS[${#MAPS[*]}]="138"
  MAPS[${#MAPS[*]}]="30"
  MAPS[${#MAPS[*]}]="130"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="New Zealand"
  MAPS[${#MAPS[*]}]="NEW_ZEALAND"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="-27"
  MAPS[${#MAPS[*]}]="-172"
  MAPS[${#MAPS[*]}]="-57"
  MAPS[${#MAPS[*]}]="155"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Papua New Guinea"
  MAPS[${#MAPS[*]}]="PAPUA_NEW_GUINEA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="0"
  MAPS[${#MAPS[*]}]="153"
  MAPS[${#MAPS[*]}]="-12"
  MAPS[${#MAPS[*]}]="134"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Red Sea"
  MAPS[${#MAPS[*]}]="RED_SEA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="33.5"
  MAPS[${#MAPS[*]}]="51"
  MAPS[${#MAPS[*]}]="9"
  MAPS[${#MAPS[*]}]="30"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Himalaya"
  MAPS[${#MAPS[*]}]="HIMALAYA"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="40.9250"
  MAPS[${#MAPS[*]}]="107.0916"
  MAPS[${#MAPS[*]}]="4.4750"
  MAPS[${#MAPS[*]}]="62.2583"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Mid-Ocean Ridges: EPR 8-11 N"
  MAPS[${#MAPS[*]}]="MID_OCEAN_RIDGES_EPR_8_11_N"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="11"
  MAPS[${#MAPS[*]}]="-102"
  MAPS[${#MAPS[*]}]="8"
  MAPS[${#MAPS[*]}]="-106"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Mid-Ocean Ridges: JdF Endeavour"
  MAPS[${#MAPS[*]}]="MID_OCEAN_RIDGES_JDF_ENDEAVOUR"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="48.5"
  MAPS[${#MAPS[*]}]="-128.5"
  MAPS[${#MAPS[*]}]="47.5"
  MAPS[${#MAPS[*]}]="-129.5"
  MAPS[${#MAPS[*]}]=""

  MAPS[${#MAPS[*]}]="Mid-Ocean Ridges: Lau Basin"
  MAPS[${#MAPS[*]}]="MID_OCEAN_RIDGES_LAU_BASIN"
  MAPS[${#MAPS[*]}]="download_with_mapbox"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="-19"
  MAPS[${#MAPS[*]}]="-173.5"
  MAPS[${#MAPS[*]}]="-23"
  MAPS[${#MAPS[*]}]="-178"
  MAPS[${#MAPS[*]}]=""

  # USGS

  MAPS[${#MAPS[*]}]="Earth's moon"
  MAPS[${#MAPS[*]}]="ULCN2005_grid.txt"
  MAPS[${#MAPS[*]}]="download_and_extract_gz"
  MAPS[${#MAPS[*]}]="28M"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="http://pubs.usgs.gov/of/2006/1367/dems/Arc_grids/ULCN2005_grid.txt.gz"

  MAPS[${#MAPS[*]}]="Venus"
  MAPS[${#MAPS[*]}]="JoliotCurie_preliminary%JoliotCurie_mrg.asc"
  MAPS[${#MAPS[*]}]="download_and_extract_zip"
  MAPS[${#MAPS[*]}]="193M"
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]=""
  MAPS[${#MAPS[*]}]="ftp://pdsimage2.wr.usgs.gov/pub/pigpen/venus/Topography/JoliotCurie/JoliotCurie_preliminary.zip"


  function utils_maps_get_name
  {
    printf "%s" "${MAPS[$1]}"
  }

  function utils_maps_get_filename
  {
    printf "%s" "${MAPS[$(($1 + 1))]%\%*}"
  }

  function utils_maps_get_archive_filename
  {
    printf "%s" "${MAPS[$(($1 + 1))]#*\%}"
  }

  function utils_maps_get_download_link
  {
    printf "%s" "${MAPS[$(($1 + 8))]}"
  }

  function utils_maps_get_coor
  {
    case "$1" in
      "NORTH")
        printf "%s" "${MAPS[$(($2 + 4))]}"; ;;
      "EAST")
        printf "%s" "${MAPS[$(($2 + 5))]}"; ;;
      "SOUTH")
        printf "%s" "${MAPS[$(($2 + 6))]}"; ;;
      "WEST")
        printf "%s" "${MAPS[$(($2 + 7))]}"; ;;
    esac
  }

fi
