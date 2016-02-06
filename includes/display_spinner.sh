#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function display_spinner
  {
    local pid=$1
    local total_delay=0
    local total_delay2=240
    local delay=0.2
    local spinstr='|/-\'
    printf $C_BLUE""
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ];
    do
      if (( $total_delay2 < 1 ))
      then
        kill $pid
        wait $! 2>/dev/null
        (( total_delay2 = $total_delay / 5 ))
        printf $C_RED"  Time out ($total_delay2 sec)"$C_CLEAR > $RETURNPATH/.myret
      fi
      if [ "$OPT_NO_TIMEOUT" == "0" ]
      then
        (( total_delay += 1 ))
      fi
      local temp=${spinstr#?}
      printf "  [%c] " "$spinstr"
      local spinstr=$temp${spinstr%"$temp"}
      if (( $total_delay >= 5 ))
      then
        (( total_delay2 = ( 209 - $total_delay ) / 5 ))
        printf "[time out: %02d]" "$total_delay2"
      fi
      sleep $delay
      printf "\b\b\b\b\b\b"
      if (( $total_delay >= 5 ))
      then
        printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
      fi
    done
    printf "                     \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    printf $C_CLEAR""
  }

fi
