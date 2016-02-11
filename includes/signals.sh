#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  declare CURRENT_CHILD_PROCESS_PID=""

  function utils_catch_signals
  {
    trap "utils_do_sigint" SIGINT
  }

  function utils_do_sigint
  {
    if [ "${CURRENT_CHILD_PROCESS_PID}" == "" ]
    then
      utils_exit
    else
      kill "${CURRENT_CHILD_PROCESS_PID}" 2>/dev/null
      wait $! 2>/dev/null
      display_error "killed pid: ${CURRENT_CHILD_PROCESS_PID}"
      if [ "${1}" != "" ]
      then
        eval "${1}"
      fi
    fi
  }

fi
