#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  declare -a DATA_PROVIDERS
  declare -i DATA_PROVIDERS_SHIFT=5

  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="IGN (National Institute of Geographic and Forest Information / France)"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="Horizontal accuracy up to 250 meters"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="http://professionnels.ign.fr/sites/default/files/"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="ocean_topography_unavailable"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="IGN"

  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="NOAA (National Oceanic and Atmospheric Administration / USA)"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="Horizontal accuracy up to 1852 meters"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="https://gis.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=MAPGEN_MAPBOX&filename=tmp.asc"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="ocean_topography_available"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="NOAA"

  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="MGDS (Marine Geoscience Data System / USA)"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="Horizontal accuracy up to 100 meters"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="http://www.marine-geo.org/services/GridServer?minlongitude=MAPGEN_WEST&maxlongitude=MAPGEN_EAST&minlatitude=MAPGEN_SOUTH&maxlatitude=MAPGEN_NORTH&format=esriascii&layer=topo&resolution=high"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="ocean_topography_available"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="MGDS"

  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="USGS (Astrogeology Science Center / USA)"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="Horizontal accuracy up to 100 meters"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="http://pubs.usgs.gov/of/2006/1367/dems/Arc_grids/"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="ocean_topography_available"
  DATA_PROVIDERS[${#DATA_PROVIDERS[*]}]="USGS"

  function utils_data_provider_id
  {
    case $1 in
      "IGN")  printf "0" ;;
      "NOAA") printf "$((1 * ${DATA_PROVIDERS_SHIFT}))" ;;
      "MGDS") printf "$((2 * ${DATA_PROVIDERS_SHIFT}))" ;;
      "USGS") printf "$((3 * ${DATA_PROVIDERS_SHIFT}))" ;;
    esac
  }

  function utils_data_provider_get_url
  {
    printf "%s" "${DATA_PROVIDERS[$(($1 + 2))]}"
  }

  function utils_data_provider_get_abbr
  {
    printf "%s" "${DATA_PROVIDERS[$(($1 + 4))]}"
  }

fi
