#!/bin/env bash
read -r -d '' USAGE << EOUSAGE
USAGE: ./license_hack.sh [OPTIONS ...]
\n\n all\t\t- Reset trial licenses for all JetBrains products
\n intellij\t- Reset trial license for IntelliJ
\n clion\t\t- Reset trial for CLion
\n pycharm\t- Reset trial for PyCharm
EOUSAGE

getHomeDir() {
 local usr=$(whoami)
 eval echo "~$usr"
}

resetTrial() {
 local lArgs=($@)
 [[ ${#lArgs[@]} > 1 ]] || [[ ${#lArgs[@]} == 0 ]] && echo -1 && return;
 local home=$(getHomeDir)
 local ret=$(
  case $lArgs in
   "all") echo "intellijidea clion pycharm";;
   "intellij") echo "intellijidea";;
   "clion") echo "clion";;
   "pycharm") echo "pycharm";;
   *) echo -1;;
  esac)
 [[ $ret == -1 ]] && echo -1 && return;
 rm -rf "$home/.java/.userPrefs/" "$home/.local/share/JetBrains"
 local apply=""
 for exp in $ret; do
  local findMe=$(ls -a $home | grep -i $exp)
  [[ -n $findMe ]] && continue;
  cd $home
  apply=$apply$(find ./$findMe)
  local ex=$(find ./$findMe | grep -vi "\.\/")
  ex=($ex)
  for exclude in $ex; do
   apply=$(echo $apply | grep -vi $exclude)
  done
  rm -rf "$home/$findMe/config/eval" "$home/$findMe/config/options/options.xml"
 done
# for file in $apply; do touch $file; done
 echo 0;
 return;
}

[[ $(resetTrial "$@") == 0 ]] && printf '%b ' "License renewal successful!" && exit 0;
printf '%b ' $USAGE
