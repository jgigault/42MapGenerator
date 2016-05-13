#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_menu
  {
    local -a MENU FUNCS
    local TOTAL SEL LEN SELN TITLE i MAPSA
    SEL=""
    if [ "$1" != "" ]
    then
      printf $1
    else
      printf "${C_INVERT}"
    fi
    shift 1
    TITLE="$1"
    if [ "${TITLE}" != "" ]
    then
      printf "%${COLUMNS}s" " "
      printf "\n"
      (( LEN=${COLUMNS} - ${#TITLE} - 3 ))
      printf "  ${TITLE} "
      printf "%"$LEN"s\n" " "
    fi
    printf "%${COLUMNS}s\n" " "
    shift 1
    while (( $# > 0 ))
    do
      if [ "$1" == "_" ]
      then
        printf "%${COLUMNS}s" " "
        printf "\n"
        shift 1
      else
        if [ "$1" == "MAPS" ]
        then
          i=0
          MAPSA="$2[${i}]"
          while [ ! -z "${!MAPSA}" ]
          do
            (( TOTAL += 1 ))
            FUNCS[$TOTAL]="$3 $((${MAPSA} * ${MAPS_SHIFT}))"
            MENU[$TOTAL]="${!MAPSA}"
            if [ "${MAPS[$((${MAPSA} * ${MAPS_SHIFT} + 3))]}" != "" ]
            then
              TITLE=`echo "${MAPS[$((${MAPSA} * ${MAPS_SHIFT}))]} (${MAPS[$((${MAPSA} * ${MAPS_SHIFT} + 3))]})" | sed 's/%/%%/g'`
            else
              TITLE=`echo "${MAPS[$((${MAPSA} * ${MAPS_SHIFT}))]}" | sed 's/%/%%/g'`
            fi
            if (( $TOTAL < 10 ))
            then
              SELN=${TOTAL}
            else
              (( SELN=65 + ${TOTAL} - 10 ))
              SELN=`echo "${SELN}" | awk '{printf("%c", $0)}'`
            fi
            (( LEN=${COLUMNS} - ${#TITLE} - 9 ))
            printf "  ${SELN})    ${TITLE} "
            printf "%${LEN}s" " "
            printf "\n"
            (( i++ ))
            MAPSA="$2[${i}]"
          done
          shift 3
        else
          (( TOTAL += 1 ))
          FUNCS[$TOTAL]="$1"
          MENU[$TOTAL]="$2"
          TITLE=`echo "$2" | sed 's/%/%%/g'`
          if (( $TOTAL < 10 ))
          then
            SELN=$TOTAL
          else
            (( SELN=65 + $TOTAL - 10 ))
            SELN=`echo "$SELN" | awk '{printf("%c", $0)}'`
          fi
          (( LEN=$COLUMNS - ${#TITLE} - 9 ))
          printf "  "$SELN")    $TITLE "
          printf "%"$LEN"s" " "
          printf "\n"
          shift 2
        fi
      fi
    done

    printf "%"$COLUMNS"s" " "
    printf ${C_CLEAR}""
    read -r -s -n 1 SEL
    SEL=$(display_menu_get_key $SEL)
    if [ "$SEL" == "ESC" ]
    then
      utils_exit
    fi
    SEL=`display_menu_atoi "$SEL"`
    while [ -z "${MENU[$SEL]}" -o "$(echo "${FUNCS[$SEL]}" | grep '^open ')" != "" ]
    do
      printf "\a"
      if [ "$(echo "${FUNCS[$SEL]}" | grep '^open ')" != "" ]
      then
        if [ -f "$(echo "${FUNCS[$SEL]}" | sed 's/^open //')" -o -d "$(echo "${FUNCS[$SEL]}" | sed 's/^open //')" -o "$(echo "${FUNCS[$SEL]}" | grep http)" != "" ]
        then
          eval ${FUNCS[$SEL]}
        fi
      fi
      SEL=""
      read -s -n 1 SEL
      SEL=$(display_menu_get_key $SEL)
      if [ "$SEL" == "ESC" ]
      then
        utils_exit
      fi
      SEL=`display_menu_atoi "$SEL"`
    done
    printf "\n"
    if [ "${FUNCS[$SEL]}" != "" ]
    then
      eval ${FUNCS[$SEL]}
    fi
  }

  function display_menu_get_key
  {
    local ord_value old_tty_settings key
    ord_value=$(printf '%d' "'$1")
    if [[ ${ord_value} -eq 27 ]]; then
      old_tty_settings=`stty -g`
      stty -icanon min 0 time 0
      read -s key
      if [[ ${#key} -eq 0 ]]
      then
        printf "ESC"
      else
        printf "NULL"
      fi
      stty "${old_tty_settings}"
    else
      printf "%s" "$1"
    fi
  }

  function display_menu_atoi
  {
    local SELN
    if [ "$1" == "NULL" ]
    then
      printf "0"
    else
      if [ "$1" != "1" -a "$1" != "2" -a "$1" != "3" -a "$1" != "4" -a "$1" != "5" -a "$1" != "6" -a "$1" != "7" -a "$1" != "8" -a "$1" != "9" ]
      then
        SELN=`LC_CTYPE=C printf '%d' "'$1"`
        if (( $SELN >= 65 )) && (( $SELN <= 90 ))
        then
          (( SELN=$SELN - 65 + 10 ))
          printf "$SELN"
        else
          if (( $SELN >= 97 )) && (( $SELN <= 122 ))
          then
            (( SELN=$SELN - 97 + 10 ))
            printf "$SELN"
          else
            printf "0"
          fi
        fi
      else
        printf "$1"
      fi
    fi
  }

fi
