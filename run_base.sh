#!/bin/bash
# author: Adan Escobar, Computer Engineer
# email: aescobar@codeits.cl
PROJECT_NAME=$(basename "`pwd`")
cd ..
DIR_BASE=$(pwd)
cd $PROJECT_NAME

Red='\033[0;31m'
Green='\033[0;32m'
BrownOrange='\033[0;33m'
NoColor='\033[0m' # No Color
#FUNCTIONS
function log(){
	echo -e "${Green}[AE.BUILD]${BrownOrange} $1 ${NoColor}"
}
function errorlog(){
	echo -e "${Green}[AE.BUILD]${Red} $1 ${NoColor}"
}
function setColorLog(){
	echo -e "$1\c"
}


