#!/bin/env bash
USAGE="Test Usage!"
parseArgs() {
 local args="$@"
 local ret=""
 for arg in $args 
 do
  ret=$(
   case $arg in
    ("all") echo "a"; break;;
    ("idea") echo "i"$ret;;
    ("intellij") echo "i"$ret;;
    ("clion") echo "c"$ret;;
    ("pycharm") echo "p"$ret;;
    (*) echo; break;;
   esac)
 done
 echo $ret
}

isFileOrDir() {
 if [[ ! -d $1 && ! -f $1 ]]; then
  echo -1
 fi
 if [ -d $1 ]; then
  echo "dir"
 elif [ -f $1 ]; then
  echo "file"
 fi
}

pathExists() {
 local path=$1
 #isSymb?
 if [ -L $path ]; then
  path=$(readlink -f $path)
 fi
 if [[ $(isFileOrDir $path) == -1 ]]; then
  echo false
 else
  echo true
 fi
}

getHomeDir() {
 local usr=$(whoami)
 eval echo "~$usr"
}

resetIntelliJ() {
 local homeDir=$(getHomeDir)
 rm -rf $(find $homeDir -maxdepth 1 -type d -name '*.IntelliJIdea*')"/config/eval"
 rm -rf $(getHomeDir)".local/share/JetBrains"
}

resetCLion() {
 local homeDir=$(getHomeDir)
  rm -rf $(find $homeDir -maxdepth 1 -type d -name '*.PyCharm*')"/config/eval"
 rm -rf $(getHomeDir)".local/share/JetBrains"
}

resetPyCharm() {
 local homeDir=$(getHomeDir)
 rm -rf $(find $homeDir -maxdepth 1 -type d -name '*.CLion*')"/config/eval"
 rm -rf $(getHomeDir)".local/share/JetBrains"
}

delete() {
 local args=$(parseArgs "$@")
 if [[ ${#args} -le 0 || ${#args} -gt 3 ]]; then
  echo -1;
 else 
  if [[ $args == *"a"* ]]; then
   resetIntelliJ; resetCLion; resetPyCharm;
  elif [[ $args == *"i"* ]]; then
   resetIntelliJ;
  elif [[ $args == *"c"* ]]; then
   resetCLion;
  elif [[ $args == *"p"* ]]; then
   resetPyCharm;
  fi
 fi
}

ret=$(delete "$@")
if [[ $ret == -1 ]]; then
 echo -e $USAGE
else
 echo "License renewal successful!"
fi
