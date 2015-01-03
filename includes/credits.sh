#!/bin/bash

if [ "$MAPGENERATOR_SH" == "1" ]
then

	function display_credits
	{
		local SEL
		clear
		display_header
		display_righttitle ""
		printf "  42MapGenerator is a tiny bash script developped at 42 school for downloading and generating maps for FdF project.\n\n"
		printf "  The script has the following dependencies:\n\n"
		printf "  -> "$C_WHITE"MNT BD Alti® - IGN\n"$C_CLEAR
		printf "     http://professionnels.ign.fr/bdalti\n\n"
		printf "  -> "$C_WHITE"ETOPO1 - NGDC Grid Extraction Tool - NOAA\n"$C_CLEAR
		printf "     http://maps.ngdc.noaa.gov/viewers/wcs-client\n\n"
		printf "  -> "$C_WHITE"Google Geocoding API\n"$C_CLEAR
		printf "     https://developers.google.com/maps/documentation/geocoding/\n\n"
		printf "\n  Press ENTER to continue..."
		read -s SEL
		main
	}

fi;