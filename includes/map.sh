#!/bin/bash

if [ "$MAPGENERATOR_SH" == "1" ]
then

	declare -a MAPS='("http://professionnels.ign.fr/sites/default/files/" "France_250_ASC_L93" "ign" "France Métropolitaine" "http://professionnels.ign.fr/sites/default/files/" "Guadeloupe_MNT250_ASC" "ign" "Guadeloupe" "http://professionnels.ign.fr/sites/default/files/" "Martinique_MNT250_ASC" "ign" "Martinique" "http://professionnels.ign.fr/sites/default/files/" "Reunion_MNT250_ASC" "ign" "Réunion" "http://professionnels.ign.fr/sites/default/files/" "Guyane_MNT250_ASC" "ign" "Guyane" "http://professionnels.ign.fr/sites/default/files/" "ST_MART_ST_BART_MNT250_ASC" "ign" "Saint Martin - Saint Barthélémy" "http://mapserver.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?filename=NOAA_ETOPO_EUROPE.asc&request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=-13.0916666666666669285,35.5916666666666673785,31.6583333333333339665,59.0250000000000011805" "NOAA_ETOPO_EUROPE" "noaa" "Europe" "http://mapserver.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?filename=NOAA_ETOPO_WEST_COAST.asc&request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=-127.3250000000000025465,14.0083333333333336135,-94.4416666666666685555,46.3250000000000009265" "NOAA_ETOPO_WEST_COAST" "noaa" "West Coast (North America)" "http://mapserver.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?filename=NOAA_ETOPO_AMAZONIA.asc&request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=-82.8583333333333349905,-17.9916666666666670265,-33.3583333333333340005,13.2416666666666669315" "NOAA_ETOPO_AMAZONIA" "noaa" "Amazonia (South America)" "http://mapserver.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?filename=NOAA_ETOPO_HIMALAYA.asc&request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=62.2583333333333345785,4.4750000000000000895,107.0916666666666688085,40.9250000000000008185" "NOAA_ETOPO_HIMALAYA" "noaa" "Himalaya (Asia)" "http://mapserver.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?filename=NOAA_ETOPO_NEWZEALAND.asc&request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=165.4083333333333366415,-47.8250000000000009565,179.6083333333333369255,-33.8916666666666673445" "NOAA_ETOPO_NEWZEALAND" "noaa" "New Zealand" "http://mapserver.ngdc.noaa.gov/cgi-bin/public/wcs/etopo1.asc?filename=NOAA_ETOPO_ITALY.asc&request=getcoverage&version=1.0.0&service=wcs&coverage=etopo1&CRS=EPSG:4326&format=aaigrid&resx=0.016666666666666667&resy=0.016666666666666667&bbox=6.6750000000000001335,36.4916666666666673965,18.7916666666666670425,46.0083333333333342535" "NOAA_ETOPO_ITALY" "noaa" "Italy")'

	function gen_header
	{
		printf $C_GREY""
		display_center "$MAPNAME"
		printf "\n"$C_CLEAR
	}

	function gen_map
	{
		local MYCONF index MAPNAME MAPURL LHOME LPATH MAPTYPE WIDTH0
		local ERASE=0
		local ERASE_ALL=0
		LHOME=`echo "$HOME" | sed 's/\//\\\\\\//g'`
		MYCONF=$(get_config "$1")
		(( index=$1 * 4 ))
		MAPURL=${MAPS[index]}
		(( index=$index + 1 ))
		MAPFILENAME=${MAPS[index]}
		(( index=$index + 1 ))
		MAPTYPE=${MAPS[index]}
		(( index=$index + 1 ))
		MAPNAME=${MAPS[index]}
		local LIST=""

		if [ ! -f "$RETURNPATH/tmp/$MAPFILENAME.txt" ]
		then
			if [ "$MAPTYPE" == "ign" ]
			then
				download_map "$MAPURL$MAPFILENAME.zip" "$RETURNPATH/tmp/$MAPFILENAME.zip"
				extract_map "$RETURNPATH/tmp" "$MAPFILENAME.zip"
			else
				download_map "$MAPURL" "$RETURNPATH/tmp/$MAPFILENAME.asc"
				mv "$RETURNPATH/tmp/$MAPFILENAME.asc" "$RETURNPATH/tmp/$MAPFILENAME.txt"
			fi
		fi
		display_header
		gen_header
		printf $C_BLUE"  Initialization...\n"$C_CLEAR

		(cat "$RETURNPATH/tmp/$MAPFILENAME.txt" | awk '{if(NR==7) {print NF}}' > .myret) &
		display_spinner $!
		WIDTH0=`cat .myret`
		MYPATH=$(get_config "export_path")
		if [ ! -d "$MYPATH" -o "$MYPATH" == "" ]
		then
			config_path
			MYPATH=$(get_config "export_path")
		else
			display_header
			gen_header
			LPATH="$MYPATH"
			LPATH="echo \"$LPATH\" | sed 's/$LHOME/~/'"
			LPATH=`eval $LPATH`
			printf $C_WHITE"  Current export directory:\n"$C_CLEAR
			printf "  "$MYPATH"\n\n"
			display_menu\
				""\
				"" "use current configuration"\
				config_path "change directory"
			MYPATH=$(get_config "export_path")
		fi
		parse_map XXL "$MYPATH/$MAPFILENAME.XXL.fdf"
		parse_map XL "$MYPATH/$MAPFILENAME.XL.fdf"
		parse_map L "$MYPATH/$MAPFILENAME.L.fdf"
		parse_map M "$MYPATH/$MAPFILENAME.M.fdf"
		parse_map S "$MYPATH/$MAPFILENAME.S.fdf"

		display_header
		gen_header
		LPATH="$MYPATH"
		LPATH="echo \"$LPATH\" | sed 's/$LHOME/~/'"
		LPATH=`eval $LPATH`
		printf $C_WHITE"  Current export directory:\n"$C_CLEAR
		printf "  "$MYPATH"\n\n"
		if [ "$LIST" == "" ]
		then
			printf $C_BLUE"  Nothing to do.\n$LIST\n"$C_CLEAR
		else
			printf $C_BLUE"  Done.\n$LIST\n"$C_CLEAR
		fi
		sleep 0.3
		display_menu\
			""\
			"main" "BACK TO MAIN MENU"\
			"exit_generator" "EXIT"
	}


	function config_parse
	{
		display_header
		#todo
	}

	function parse_map
	{
		local step=1
		local zfactor=2
		local unknown=-130
		local water=-130
		case "$1" in
			"XL")
				step=2
				#zfactor=5
				water=-60
				unknown=-60
				;;
			"L")
				step=4
				#zfactor=10
				water=-30
				unknown=-30
				;;
			"M")
				step=8
				#zfactor=20
				water=-15
				unknown=-15
				;;
			"S")
				step=16
				#zfactor=40
				water=-10
				unknown=-10
				;;
		esac
		ERASE=0
		display_header
		gen_header
		printf $C_WHITE"  Current export directory:\n"$C_CLEAR
		printf "  "$MYPATH"\n\n"
		printf $C_BLUE"  Generating $1 map...\n"
		(( XFACTOR=$WIDTH0 / $step ))
		(( XFACTOR=$XFACTOR * 100 ))
		(( XFACTOR=$XFACTOR / $WIDTH0 ))
		(( zfactor=$zfactor * $XFACTOR ))
		(( zfactor=$zfactor / 100  + 1))

		zfactor=16
		(( water=10 - 10 * 100 / $WIDTH0 ))
		(( water=$water * 2 ))
		if (( $water <= 5 ))
		then
			water=5
		fi
		(( water= $water * -1 ))
		unknown=$water

		if [ -f "$2" -a "$ERASE_ALL" == "0" ]
		then
			printf $C_RED"  !!! This map already exists. !!!\n\n"
			display_menu\
				""\
				"erase_map \"$1\" \"$2\"" "erase map"\
				"erase_map_all \"$1\" \"$2\"" "erase all maps"\
				"" "skip warning"
		else

			(cat "$RETURNPATH/tmp/$MAPFILENAME.txt" | awk -v step=$step -v zfactor=$zfactor -v unknown=$unknown -v water=$water 'BEGIN {odd=-1} {if(NR > 6) {odd+=1; if(odd==0) {for(i=1;i<=NF;i++) {if($i==-9999) {printf unknown} else {if($i<=0) {printf water} else {printf("%d", $i/zfactor+1)}} i+=step; if(i>=NF) {printf "\n"} else {printf " "}}} else {if (odd>=step) {odd=-1}}}}' > "$2") &
			display_spinner $!
			LIST=$LIST"  -> $MAPFILENAME.$1.fdf\n"
		fi
	}

	function erase_map_all
	{
		ERASE_ALL=1
		erase_map "$1" "$2"
	}

	function erase_map
	{
		rm -f "$2"
		printf ""$C_CLEAR
		parse_map "$1" "$2"
	}

	function download_map
	{
		create_tmp_dir
		display_header
		gen_header
		printf $C_BLUE"  Downloading map from remote server...\n  "
		sleep 0.5
		rm -f "$2"
		curl --output "$2" "$1"
		printf $C_CLEAR""
		if [ ! -f "$2" ]
		then
			display_error "An error occured while downloading file"
			exit_generator
		fi
	}

	function extract_map
	{
		local RET0
		display_header
		gen_header
		printf $C_BLUE"  Extracting map from archive...\n  "
		sleep 0.5
		rm -f "$1/"*.ASC
		unzip -d "$1" "$1/$2" *.[Aa][Ss][Cc]
		printf $C_CLEAR""
		RET0=`find "$1" -name *.[Aa][Ss][Cc] | awk '{if(NR==1) {print}}'`
		if [ "$RET0" == "" ]
		then
			display_error "An error occured while extracting file"
			exit_generator
		fi
		echo $RET0
		mv "$RET0" "$1/$MAPFILENAME.txt"
		rm -f "$1/$2"
	}

fi;