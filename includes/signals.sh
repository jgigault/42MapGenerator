#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  declare CURRENT_CHILD_PROCESS_PID=""

  function utils_catch_signals
  {
    trap "utils_catch_signals_sigint" SIGINT
  }

  function utils_catch_signals_sigint
  {
    if [ "${CURRENT_CHILD_PROCESS_PID}" == "" ]
    then
      utils_exit
    else
      kill "${CURRENT_CHILD_PROCESS_PID}"
      wait $! 2>/dev/null
    fi
  }

fi
