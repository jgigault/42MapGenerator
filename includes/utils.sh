#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  declare MAPS_TMPDIR="./tmp/"

  function utils_set_env
  {
    COLUMNS=`tput cols`
    if [ "${COLUMNS}" == "" ]
    then
      COLUMNS=80
    fi
    export LC_NUMERIC=C LC_COLLATE=C LANG=C
  }

  function utils_set_colors
  {
    if [ "${OPT_NO_COLOR}" == "0" ]
    then
      C_BLACKBG="\033[48;5;233m""\033[38;5;249m"
      C_CLEAR="\033[0m"$C_BLACKBG
      C_YELLOW=$C_BLACKBG"\033[33;1m"
      C_RED=$C_BLACKBG"\033[31m\033[38;5;208m"
      C_GREEN=$C_BLACKBG"\033[32m\033[38;5;77m"
      C_CYAN=$C_BLACKBG"\033[36;1m"
      C_WHITE=$C_BLACKBG"\033[37;1m"
      C_BLUE=$C_BLACKBG"\033[38;5;12m"
      C_GREY=$C_BLACKBG"\033[38;5;239m"
      C_BLACK="\033[30;1m"
      C_INVERT="\033[48;5;234m""\033[38;5;248m"
      C_INVERT2="\033[48;5;233m""\033[38;5;242m"
      C_INVERTGREY="\033[48;5;248m""\033[38;5;235m"
      C_INVERTRED="\033[48;5;52m""\033[38;5;107m"
    else
      C_BLACKBG=
      C_CLEAR="\033[0m"
      C_YELLOW=
      C_RED=
      C_GREEN=
      C_CYAN=
      C_WHITE=
      C_BLUE=
      C_GREY=
      C_GREY=
      C_BLACK=
      C_INVERT=
      C_INVERT2=
      C_INVERTGREY=
      C_INVERTRED=
    fi
  }

  function utils_start
  {
    tput civis
    tput smcup
    utils_set_env
    utils_set_colors
    utils_catch_signals
    utils_update
    utils_exit
  }

  function utils_before_exit
  {
    printf "\n\n\n\n\033[0m"
    tput cnorm
    tput rmcup
  }

  function utils_exit
  {
    utils_before_exit
    cd "${GLOBAL_ENTRYPATH}"
    exit
  }

  function utils_clear
  {
    printf ${C_CLEAR}""
    tput cup 0 0
    tput cd
  }

  function utils_option_set
  {
    case "$1" in
      "OPT_NO_TIMEOUT")
        if [ "$OPT_NO_TIMEOUT" == 1 ]; then OPT_NO_TIMEOUT=0; else OPT_NO_TIMEOUT=1; fi
        ;;
      "OPT_NO_COLOR")
        if [ "$OPT_NO_COLOR" == 1 ]; then OPT_NO_COLOR=0; else OPT_NO_COLOR=1; fi
        utils_set_colors
        ;;
    esac
    main
  }

  function create_tmp_dir
  {
    if [ ! -d "${MAPS_TMPDIR}" ]
    then
      mkdir "${MAPS_TMPDIR}"
    fi
    if [ ! -d "${MAPS_TMPDIR}" ]
    then
      display_header
      display_section
      display_error "An error occured while creating temporary folder"
      display_menu\
        "" ""\
        "${RETURNFUNCTION}" "OK"\
        "_"\
        "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
        "utils_exit" "EXIT"
    else
      if [ "$1" != "" -a ! -d "${MAPS_TMPDIR}${1}" ]
      then
        mkdir "${MAPS_TMPDIR}${1}"
        if [ ! -d "${MAPS_TMPDIR}${1}" ]
        then
          display_header
          display_section
          display_error "An error occured while creating temporary folder"
          display_menu\
            "" ""\
            "${RETURNFUNCTION}" "OK"\
            "_"\
            "open https://github.com/jgigault/42MapGenerator/issues/new" "REPORT A BUG"\
            "utils_exit" "EXIT"
        fi
      fi
    fi
  }

  function utils_get_config
  {
    if [ ! -f ".my$1" ]
    then
      touch ".my$1"
    fi
    printf "%s" "$(cat ".my$1")"
  }

  function utils_save_config
  {
    printf "%s" "$2" > ".my$1"
  }

fi