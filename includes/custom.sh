#!/bin/bash
if [ "$MAPGENERATOR_SH" == "1" ]
then

	declare API_KEY="AIzaSyAO_R8YeQL6Zgl1d-E_H3Y9h3ZF_yZ9meI"
	declare STATUS=$(cat ".mycustomSTATUS")

	function gen_custom
	{
		local LAT0 LNG0 LAT1 LNG1 TITLE RET0 JSON0 MSG
		LAT0=$(cat ".mycustomLAT0")
		LAT1=$(cat ".mycustomLAT1")
		LNG0=$(cat ".mycustomLNG0")
		LNG1=$(cat ".mycustomLNG1")
		TITLE=$(cat ".mycustomTITLE")
		display_header
		gen_custom_header
		if [ "$STATUS" == "OK" ]
		then
			gen_custom_header_config
			display_menu\
				""\
				gen_map_custom "generate map"\
				gen_custom_config "find other coordinates by country name"\
				main "BACK TO MAIN MENU"
		else
			if [ "$STATUS" != "" ]
			then
				case "$STATUS" in
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
				esac
				printf $C_RED"  $MSG\n\n"$C_CLEAR
			fi
			display_menu\
				""\
				gen_custom_config "find coordinates by country name"\
				main "BACK TO MAIN MENU"
		fi
	}

	function gen_custom_config
	{
		local RET0 JSON0 JSON1 TITLE2 SHORTTITLE
		STATUS=""
		TITLE=""
		save_config customTITLE ""
		save_config customSTATUS ""
		while [ "$TITLE" == "" ]
		do
			display_header
			gen_custom_header
			tput cnorm
			printf $C_WHITE""
			read -p "  Type a country name (e.g. Spain): " -e TITLE
			printf $C_CLEAR""
			tput civis
			if [ "$TITLE" != "" ]
			then
				TITLE2=`echo "$TITLE" | sed 's/ /+/g'`
				display_header
				gen_custom_header
				printf $C_BLUE"  Looking for coordinates...\n"
				sleep 0.3
				(curl -s "https://maps.googleapis.com/maps/api/geocode/json?components=country:$TITLE2&key=$API_KEY" > .myret 2>&1) &
				display_spinner $!
				JSON0=`cat .myret | sed 's/[" ,]//g'`
				STATUS=`echo "$JSON0" | grep "status" | cut -d: -f2 | sed 's/[ \t]*//g'`
				if [ "$STATUS" == "OK" ]
				then
					TITLE=`cat .myret | sed 's/[",]//g' | grep "formatted_address" | cut -d":" -f2 | sed 's/^[ ]*//g' | sed 's/[ ]*$//g'`
					JSON1=`echo "$JSON0" | awk 'BEGIN {OFS=""; VIEWPORT=0; NORTHEAST=0; SOUTHWEST=0 } $0 ~ /viewport/ {VIEWPORT=1} $0 ~ /northeast/ {if (VIEWPORT==1 && NORTHEAST==0) { NORTHEAST=1 }} $0 ~ /lat/ {if (NORTHEAST>0) {printf "NE" $0 "\n"; NORTHEAST+=1}} $0 ~ /lng/ {if (NORTHEAST>0) {printf "NE" $0 "\n"; NORTHEAST+=1}} $0 ~ /southwest/ {if (VIEWPORT==1 && SOUTHWEST==0) { SOUTHWEST=1 }} $0 ~ /lat/ {if (SOUTHWEST>0) {printf "SW" $0 "\n"; SOUTHWEST+=1}} $0 ~ /lng/ {if (SOUTHWEST>0) {printf "SW" $0 "\n"; SOUTHWEST+=1}} {if (NORTHEAST==3) {NORTHEAST=-1} if(SOUTHWEST==3) {SOUTHWEST=-1}}'`
					echo "$JSON1" | grep "SWlng" | cut -d":" -f2 > .mycustomLNG0
					echo "$JSON1" | grep "NElng" | cut -d":" -f2 > .mycustomLNG1
					echo "$JSON1" | grep "SWlat" | cut -d":" -f2 > .mycustomLAT0
					echo "$JSON1" | grep "NElat" | cut -d":" -f2 > .mycustomLAT1
					echo "$TITLE" > .mycustomTITLE
				fi
				printf $C_CLEAR""
			fi
		done
		save_config customSTATUS "$STATUS"
		gen_custom
	}

	function gen_map_custom
	{
		local FNAME
		FNAME=`echo "$TITLE" | sed 's/[^0-9a-zA-Z]/_/g'`
		gen_map_cp "CUSTOM_$FNAME" "http://mapserver.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?filename=CUSTOM_$FNAME.asc&request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=$LNG0,$LAT0,$LNG1,$LAT1" "CUSTOM_$FNAME" "noaa" "$TITLE"

	}

	function gen_custom_header
	{
		printf $C_GREY""
		display_center "Customized coordinates"
		printf "\n"$C_CLEAR
	}

	function gen_custom_header_config
	{
		printf $C_WHITE"  Current configuration:\n\n"$C_CLEAR
		printf "  NorthWest:\tlat: $C_WHITE$LAT0$C_CLEAR\n"
		printf "            \tlng: $C_WHITE$LNG0$C_CLEAR\n\n"
		printf "  SouthEast:\tlat: $C_WHITE$LAT1$C_CLEAR\n"
		printf "            \tlng: $C_WHITE$LNG1$C_CLEAR\n\n"
		printf "  Title:    \t$C_WHITE$TITLE$C_CLEAR\n"
		printf "\n"

	}

fi;