#!/bin/bash

if [ "$MAPGENERATOR_SH" == "1" ]
then

  function config_path
  {
    local STARTDIR
    display_header
    display_section
    if [ "${MY_EXPORT_PATH}" == "" ]
    then
      display_error "Welcome! You must specify an export directory at first"
      printf "\n"
      display_menu\
        "" "Select a location where to find an export directory:"\
        "config_path_select HOME" "Home directory:       ~/"\
        "config_path_select TMP" "Temporary directory:  /tmp"\
        "config_path_select ROOT" "Root folder:          /"
    else
      display_menu\
        "" "Select a location where to find an export directory:"\
        "config_path_select HOME" "Home directory:       ~/"\
        "config_path_select TMP" "Temporary directory:  /tmp"\
        "config_path_select ROOT" "Root folder:          /"\
        "_"\
        "config_path_select" "CANCEL"
    fi
    display_header
    display_section
    if [ "${STARTDIR}" != "*" ]
    then
      check_configure_read
      eval "${RETURNFUNCTION}"
    else
      eval "${RETURNFUNCTION}"
    fi
  }

  function config_path_select
  {
    case "$1" in
      'TMP')
        STARTDIR="/tmp"
        ;;
      'HOME')
        STARTDIR="${HOME}"
        ;;
      'ROOT')
        STARTDIR=""
        ;;
      *)
        STARTDIR="*"
        ;;
    esac
  }

  function check_configure_read
  {
    local AB0 AB2
    printf "  Find an export directory by using the shell prompt and then press ENTER:\n  -> Use TAB to see what's inside the directories\n  -> Keep empty and press ENTER to cancel\n\n${C_INVERTGREY}"
    cd "${STARTDIR}/"
    printf "${C_WHITE}"
    tput cnorm
    read -p "  $(echo "${STARTDIR}" | sed "s/^$(echo "${HOME}" | sed 's/\//\\\//g')/~/")/" -e AB0
    tput civis
    if [ "${AB0}" == "" ]
    then
      cd "${RETURNPATH}"
      STARTDIR="*"
      return
    else
      AB0=`echo "${AB0}" | sed 's/\/$//'`
      AB2="${STARTDIR}/${AB0}"
      while [ "${AB0}" == "" -o ! -d "${AB2}" ]
      do
        display_header
        display_section
        printf "  Find an export directory by using the shell prompt and then press ENTER:\n  -> Use TAB to see what's inside the directories\n  -> Keep empty and press ENTER to cancel\n\n"$C_INVERTGREY
        printf "${C_WHITE}"
        if [ "$AB0" != "" ]
        then
          display_error "${AB2}: No such file or directory"
        else
          printf "${C_WHITE}"
        fi
        tput cnorm
        read -p "  $(echo "${STARTDIR}" | sed "s/^$(echo "${HOME}" | sed 's/\//\\\//g')/~/")" -e AB0
        tput civis
        if [ "$AB0" == "" ]
        then
          cd "${RETURNPATH}"
          STARTDIR="*"
          return
        fi
        AB0=`echo "${AB0}" | sed 's/\/$//'`
        AB2="${STARTDIR}/${AB0}"
      done
      cd "${RETURNPATH}"
      utils_save_config "export_path" "${AB2}"
      printf "${C_CLEAR}"
      return
    fi

  }


fi;