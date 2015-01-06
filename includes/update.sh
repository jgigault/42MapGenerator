#!/bin/bash

if [ "$MAPGENERATOR_SH" == "1" ]
then

	function update
	{
		local UPTODATE
		tput civis
		display_header
		display_righttitle ""
		printf "  Checking for updates...\n"
		(check_for_update > .myret) &
		display_spinner $!
		UPTODATE=`cat .myret`
		if [ "$UPTODATE" != "1" ]
		then
			if [ "$UPTODATE" == "2" ]
			then
				display_error "An error occured."
				printf $C_RED"$(cat .myret2 | awk 'BEGIN {OFS=""} {print "  ",$0}')"$C_CLEAR
				exit_generator
				printf "UPTODATE2" > .myret
			else
				printf $C_RED"  Your version of '42MapGenerator' is out-of-date.\n  Choose UPDATE 42MAPGENERATOR (1) for getting the last version or use '--no-update' to skip this message.\n\n"$C_CLEAR
				display_menu\
              	""\
                	install_update "UPDATE 42MAPGENERATOR"\
					"" "SKIP UPDATE"\
                	exit_generator "EXIT"
			fi
		fi
	}

	function check_for_update
	{
		local DIFF0
		DIFF0=`git fetch origin 2>&1 | tee .myret2 | grep fatal`
		if [ "$DIFF0" != "" ]
		then
			printf "2"
		else
			DIFF0=`git diff origin/master 2>&1 | sed 's/\"//'`
			if [ "$DIFF0" != "" ]
			then
				printf "0"
			else
				printf "1"
			fi
		fi
	}

	function install_update
	{
		local RES0
		display_header
		display_righttitle ""
		printf "  Updating 42MapGenerator\n"
		(git merge origin/master 2>&1 > .myret) &
		display_spinner $!
		RES0=`cat .myret`
		sleep 0.5
		if [ "$RES0" == "" ]
		then
			printf $C_BLUE"  Done.\n"$C_CLEAR
			sleep 0.2
			tput cnorm
			sh ./42MapGenerator.sh
		else
			RES0=`git reset --hard origin/master 2>&1`
			RES0=`git merge origin/master 2>&1`
			if [ "$RES0" == "" ]
			then
				display_error "An error occured."
				printf $C_RED"\n  You should better discard your repository and clone again.\n"$C_CLEAR
				tput cnorm
			else
				printf $C_BLUE"  Done.\n"$C_CLEAR
				sleep 0.2
				tput cnorm
				sh ./42MapGenerator.sh
			fi
		fi
	}

fi