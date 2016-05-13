#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_credits
  {
    local SEL
    clear
    display_header
    display_righttitle ""
    printf "  42MapGenerator is a tiny bash script developped at 42 school for downloading and generating maps of the real world for the pedagogic project FdF.\n\n"
    printf "  It contains the following credits:\n\n"
    printf "  -> ${C_WHITE}MNT BD Alti®\n"
    printf "     IGN National Institute of Geographic and Forest Information / France\n${C_CLEAR}"
    printf "     http://professionnels.ign.fr/bdalti\n\n"
    printf "  -> ${C_WHITE}NGDC Grid Extraction Tool\n"
    printf "     NOAA National Oceanic and Atmospheric Administration / USA\n${C_CLEAR}"
    printf "     http://maps.ngdc.noaa.gov/viewers/wcs-client\n\n"
    printf "  -> ${C_WHITE}GMRT Map Tool\n"
    printf "     MGDS Marine Geoscience Data System / USA\n${C_CLEAR}"
    printf "     Ryan, W.B.F., S.M. Carbotte, J.O. Coplan, S. O'Hara,\n"
    printf "     A. Melkonian, R. Arko, R.A. Weissel, V. Ferrini, A. Goodwillie,\n"
    printf "     F. Nitsche, J. Bonczkowski, and R. Zemsky (2009),\n"
    printf "     Global Multi-Resolution Topography synthesis, Geochem. Geophys. Geosyst.,\n"
    printf "     10, Q03014, doi: 10.1029/2008GC002332\n"
    printf "     http://www.marine-geo.org/tools/GMRTMapTool/\n\n"
    printf "  -> ${C_WHITE}USGS Planetary GIS Web Server\n"
    printf "     USGS Astrogeology Science Center / USA\n${C_CLEAR}"
    printf "     http://webgis.wr.usgs.gov/pigwad/down/index.html\n\n"
    printf "  -> ${C_WHITE}Google Geocoding API\n${C_CLEAR}"
    printf "     https://developers.google.com/maps/documentation/geocoding/\n\n"
    printf "\n  Press ENTER to continue..."
    read -s SEL
    main
  }

fi
