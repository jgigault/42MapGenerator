#!/bin/bash

if [ "$MAPGENERATOR_SH" == "1" ]
then

	function config_path
	{
		local AB0 AB2 MYPATH
		MYPATH=$(get_config "export_path")
		display_header
		if [ "$MYPATH" != "" -a -d "$MYPATH" ]
		then
			printf $C_WHITE"  Current export directory:\n"$C_CLEAR
			printf "  "$MYPATH"\n\n"
		fi
		echo "  Please type a directory to which to export the maps:"$C_WHITE
		cd "$HOME/"
		tput cnorm
		read -p "  $HOME/" -e AB0
		tput civis
		AB0=`echo "$AB0" | sed 's/\/$//'`
		AB2="$HOME/$AB0"
		while [ "$AB0" == "" -o ! -d "$AB2" ]
		do
			display_header
			echo "  Please type a directory to which to export the maps:"$C_WHITE
			if [ "$AB0" != "" ]
			then
				echo $C_RED"  $AB2: No such file or directory"$C_CLEAR$C_WHITE
			else
				printf $C_WHITE
			fi
			tput cnorm
			read -p "  $HOME/" -e AB0
			tput civis
			AB0=`echo "$AB0" | sed 's/\/$//'`
			AB2="$HOME/$AB0"
		done
		cd "$RETURNPATH"
		save_config "export_path" "$AB2"
		printf $C_CLEAR""
	}

fi;