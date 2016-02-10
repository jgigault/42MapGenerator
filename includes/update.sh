#!/bin/bash

if [ "${MAPGENERATOR_SH}" == "1" ]
then

  function utils_update
  {
    tput civis
    rm -f ".myret"
    utils_update_check
    case "$(cat ".myret")" in
      "exit")
        utils_exit
        return ;;
      "nothing")
        tput cnorm
        return ;;
    esac
    main
  }

  function utils_update_check
  { if [ "${OPT_NO_UPDATE}" == "0" ]; then
    local UPTODATE VERSION RET0 RET1 LOCALHASH REMOTEHASH LOCALBRANCH
    display_header
    printf "${C_BLUE}  %s\n" "Checking for updates..."
    (utils_update_check_diff > .myret) &
    display_spinner $!
    UPTODATE=`cat .myret`
    case "${UPTODATE}" in
      "1")
        printf "continue" > .myret
        ;;
      "3")
        display_header "${C_INVERTRED}"
        display_error "Cannot check for updates: Your Internet connection is probably down..."
        printf "\n"
        display_menu\
          "${C_INVERTRED}" ""\
          "printf 'continue' > .myret" "SKIP UPDATE"\
          "printf 'exit' > .myret" "EXIT"
        ;;
      "0")
        LOCALBRANCH=$(git branch | grep '^\*' | cut -d" " -f2)
        LOCALHASH=`git show-ref | grep "refs/heads/${LOCALBRANCH}" | cut -d" " -f1 | awk '{print; exit}'`
        REMOTEHASH=`git ls-remote 2>/dev/null | grep refs/heads/${LOCALBRANCH} | cut -f1 | awk '{print; exit}'`
        CVERSION=$(git log --oneline "refs/heads/${LOCALBRANCH}" | awk 'END {printf NR}' | sed 's/ //g')
        VERSION=$(git log --oneline "refs/remotes/origin/${LOCALBRANCH}" | awk 'END {printf NR}' | sed 's/ //g')
        display_header "${C_INVERTRED}"
        printf "${C_RED}"
        if [ "${REMOTEHASH}" != "${LOCALHASH}" -a "${REMOTEHASH}" != "" -a "${CVERSION}" -lt "${VERSION}" ]
        then
          display_center "Your version of '42MapGenerator' is out-of-date."
          display_center "REMOTE: r$VERSION       LOCAL: r$CVERSION"
          RET1=`git log --pretty=oneline "refs/remotes/origin/${LOCALBRANCH}" 2>/dev/null | awk -v lhash="${LOCALHASH}" '{if ($1 == lhash) {exit} print}' | cut -d" " -f2- | awk 'BEGIN {LIMIT=0} {print "  -> "$0; LIMIT+=1; if(LIMIT==10) {print "  -> (limited to 10 last commits...)"; exit}}'`
          if [ "$RET1" != "" ]
          then
            printf "\n\n  Most recent commits:\n%s\n\n" "$RET1"
          fi
        else
          display_center "Your copy of '42MapGenerator' has been modified locally."
          display_center "Skip update if you don't want to erase your changes."
          printf "\n\n"
        fi
        display_error "Choose UPDATE 42MAPGENERATOR (1) for installing the latest version or skip this warning by choosing SKIP UPDATE (2) or by using '--no-update' at launch."
        printf "\n"
        display_menu\
          "${C_INVERTRED}" ""\
          utils_update_install "UPDATE 42MAPGENERATOR"\
          "printf 'continue' > .myret" "SKIP UPDATE"\
          "printf 'exit' > .myret" "EXIT"
        ;;
    esac
    fi
  }

  function utils_update_check_diff
  {
    local DIFF0
    local LOCALBRANCH=$(git branch | grep '^\*' | cut -d" " -f2)
    DIFF0=`git fetch --all 2>&1 | tee .myret2 | grep fatal`
    if [ "${DIFF0}" != "" ]
    then
      printf "3"
    else
      DIFF0=`git diff "refs/remotes/origin/${LOCALBRANCH}" 2>&1 | grep -E '^\+|^\-' | sed 's/\"//'`
      if [ "$DIFF0" != "" ]
      then
        printf "0"
      else
        printf "1"
      fi
    fi
  }

  function utils_update_install
  {
    local RES0 LOCALBRANCH=$(git branch | grep '^\*' | cut -d" " -f2)
    local LOGFILENAME=".myret"
    display_header
    printf "\n"
    printf "${C_BLUE}  %s\n" "Updating 42MapGenerator..."
    rm -f ${LOGFILENAME}
    (git fetch --all >/dev/null 2>&1) &
    display_spinner $!
    (git reset --hard "origin/${LOCALBRANCH}" 2>&1 | grep -v 'HEAD is now at' >${LOGFILENAME}) &
    display_spinner $!
    RES0=`cat ${LOGFILENAME}`
    sleep 0.5
    if [ "${RES0}" == "" ]
    then
      printf "${C_BLUE}  %s\n${C_CLEAR}" "Done!"
      (git shortlog -s | awk 'BEGIN {rev=0} {rev+=$1} END {printf rev"\n"}' >.myrev 2>/dev/null) &
      display_spinner $!
      sleep 0.5
      utils_before_exit
      sh ./42MapGenerator.sh "--with-entrypath" "${GLOBAL_ENTRYPATH}"
    else
      display_error "An error occured"
      display_error "If the error persists, try to discard this directory and clone again"
      printf "\n"
      tput cnorm
    fi
    printf "nothing" >.myret
  }

fi