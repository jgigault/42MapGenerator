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
  { if [ "${OPT_NO_UPDATE}" == "0" -a "${GLOBAL_LOCALBRANCH}" != "master" ]; then
    local FORCE_UPDATE UPTODATE VERSION RET0 RET1 LOCALHASH REMOTEHASH REMOTEFETCHURL TOPLEVELINSTALLDIR

    FORCE_UPDATE=${1}
    REMOTEFETCHURL=$(git remote get-url origin)
    TOPLEVELINSTALLDIR=$(git rev-parse --show-toplevel)
    display_header
    printf "${C_BLUE}  %s\n" "Checking for updates..."
    git fetch origin
    if [ "${?}" == "0" ]
    then
      (utils_update_check_fetchurl > .myret && utils_update_check_diff > .myret) &
      display_spinner $!
      UPTODATE=`cat .myret`
    else
      UPTODATE="ERR3"
    fi
    case "${UPTODATE}" in
      "OK")
          printf "continue" > .myret
        ;;
      "ERR3")
        display_header "${C_INVERTRED}"
        display_error "Cannot check for updates because fetching origin has failed..."
        display_error "Use option '--no-update' at launch to avoid this step."
        printf "\n"
        display_menu\
          "${C_INVERTRED}" ""\
          "printf 'continue' > .myret" "SKIP UPDATE"\
          "printf 'exit' > .myret" "EXIT"
        ;;
      "ERR2")
        display_header "${C_INVERTRED}"
        display_error "42MapGenerator tried to update your local installation but it is not linked to the original repository \"${CONFIG_ORIGINAL_REPOSITORY_ID}\" on \"${CONFIG_ORIGINAL_REPOSITORY_HOST}\", but to the following remote URL:"
        display_error " "
        display_error "Remote directory: ${REMOTEFETCHURL}"
        display_error "Local directory:  ${TOPLEVELINSTALLDIR}"
        display_error " "
        display_error "If you confirm the update, it will erase your local directory with the remote one."
        printf "\n"
        display_menu\
          "${C_INVERTRED}" ""\
          "utils_update_check 1" "YES, CONTINUE UPDATE AND ERASE LOCAL DIRECTORY"\
          "printf 'skip' > .myret" "NO, SKIP UPDATE"\
          "printf 'exit' > .myret" "EXIT"
        ;;
      "ERR1")
        LOCALHASH=`git show-ref | grep "refs/heads/${GLOBAL_LOCALBRANCH}" | cut -d" " -f1 | awk '{print; exit}'`
        REMOTEHASH=`git ls-remote 2>/dev/null | grep refs/heads/${GLOBAL_LOCALBRANCH} | cut -f1 | awk '{print; exit}'`
        GLOBAL_CVERSION=$(git log --oneline "refs/heads/${GLOBAL_LOCALBRANCH}" | awk 'END {printf NR}' | sed 's/ //g')
        VERSION=$(git log --oneline "refs/remotes/origin/${GLOBAL_LOCALBRANCH}" | awk 'END {printf NR}' | sed 's/ //g')
        display_header "${C_INVERTRED}"
        printf "${C_RED}"
        if [ "${REMOTEHASH}" != "${LOCALHASH}" -a "${REMOTEHASH}" != "" -a "${GLOBAL_CVERSION}" -lt "${VERSION}" ]
        then
          display_center "Your version of '42MapGenerator' is out-of-date."
          display_center "REMOTE: r${VERSION}       LOCAL: r${GLOBAL_CVERSION}"
          RET1=`git log --pretty=oneline "refs/remotes/origin/${GLOBAL_LOCALBRANCH}" 2>/dev/null | awk -v lhash="${LOCALHASH}" '{if ($1 == lhash) {exit} print}' | cut -d" " -f2- | awk 'BEGIN {LIMIT=0} {print "  -> "$0; LIMIT+=1; if(LIMIT==10) {print "  -> (limited to 10 last commits...)"; exit}}'`
          if [ "$RET1" != "" ]
          then
            printf "\n\n  Most recent commits:\n%s\n\n" "$RET1"
          fi
        else
          display_center "Your copy of '42MapGenerator' has been locally modified."
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

  function utils_update_check_fetchurl
  {
    if [ -z "${FORCE_UPDATE}" ]
    then
      if [ "${REMOTEFETCHURL}" != "git@${CONFIG_ORIGINAL_REPOSITORY_HOST}:${CONFIG_ORIGINAL_REPOSITORY_ID}" -a "${REMOTEFETCHURL}" != "https://${CONFIG_ORIGINAL_REPOSITORY_HOST}/${CONFIG_ORIGINAL_REPOSITORY_ID}" ]
      then
        printf "ERR2"
        return 1
      fi
    fi
    return 0
  }

  function utils_update_check_diff
  {
    local DIFF0

    DIFF0=`git diff "refs/remotes/origin/${GLOBAL_LOCALBRANCH}" 2>&1 | grep -E '^\+|^\-' | sed 's/\"//'`
    if [ "$DIFF0" != "" ]
    then
      printf "ERR1"
    else
      printf "OK"
    fi
  }

  function utils_update_install
  {
    local RES0
    local LOGFILENAME=".myret"

    display_header
    printf "\n${C_BLUE}  %s\n" "Updating 42MapGenerator..."
    rm -f ${LOGFILENAME}
    (git reset --hard "origin/${GLOBAL_LOCALBRANCH}" 2>&1 | grep -v 'HEAD is now at' >${LOGFILENAME}) &
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