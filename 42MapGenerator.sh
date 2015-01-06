#!/bin/bash

####################################################################
#    jgigault @ student.42.fr                    06 51 15 98 82    #
####################################################################

MAPGENERATOR_SH=1
RETURNPATH=$(pwd | sed 's/ /\ /g')
OPT_NO_UPDATE=0
OPT_NO_COLOR=0
OPT_NO_TIMEOUT=0

i=1
while (( i <= $# ))
do
	if [ "${!i}" == "--no-update" ]
	then
		OPT_NO_UPDATE=1
	fi
	if [ "${!i}" == "--no-color" ]
	then
		OPT_NO_COLOR=1
	fi
	if [ "${!i}" == "--no-timeout" ]
	then
		OPT_NO_TIMEOUT=1
	fi
	(( i += 1 ))
done

source includes/utils.sh
source includes/map.sh
source includes/update.sh
source includes/credits.sh
source includes/config.sh
source includes/custom.sh

function main
{
	tput civis
	display_header
	display_menu\
		""\
		gen_custom "find your own country with the Google Geocoding API"\
		main_ign "preset regions: IGN's data (France and Overseas)"\
		main_noaa "preset regions: NOAA's data (World)"\
		display_credits "CREDITS"\
		"open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
		exit_generator "EXIT"
}

function main_ign
{
	display_header
	display_menu\
		""\
		"gen_map 0" "France Métropolitaine"\
		"gen_map 1" "DOM TOM: Guadeloupe"\
		"gen_map 2" "DOM TOM: Martinique"\
		"gen_map 3" "DOM TOM: Réunion"\
		"gen_map 4" "DOM TOM: Guyane"\
		"gen_map 5" "DOM TOM: Saint Martin - Saint Barthélémy"\
		main "BACK TO MAIN MENU"
}

function main_noaa
{
	display_header
	display_menu\
		""\
		"gen_map 8" "Amazonia"\
		"gen_map 14" "Australia"\
		"gen_map 13" "Cordillera de los Andes"\
		"gen_map 16" "Ethiopia"\
		"gen_map 6" "Europe"\
		"gen_map 12" "Great Britain & Ireland"\
		"gen_map 15" "Great Lakes (North America)"\
		"gen_map 9" "India & Himalaya"\
		"gen_map 11" "Italy"\
		"gen_map 10" "New Zealand"\
		"gen_map 7" "West Coast (North America)"\
		main "BACK TO MAIN MENU"
}

if [ "$OPT_NO_UPDATE" == "0" ]
then
	update
fi
main