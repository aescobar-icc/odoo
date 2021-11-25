#!/bin/bash

# author: Adan Escobar, Computer Engineer
# email: aescobar@codeits.cl
set -Eeuo pipefail
CODE_VERSION_FILE="./.code-version"

#-------------------------------------------------------
# Calculate Next Version Value.
# The new value is stored in CODE_VERSION_NEXT var
#-------------------------------------------------------
# @params:
# 	version   : current string version value
# 	limit     : indicates the value that will increment next correlative
# 	delimiter : char delimiter of string version
#
#-------------------------------------------------------
# How to use:
#-------------------------------------------------------
# code-version-calc "0.0.0"  10  "." # 0.0.0 --> 0.0.1 
# code-version-calc "0.9.9"  10  "." # 0.9.9 --> 1.0.0
# code-version-calc "0.0.45" 100 "." # "0.0.45" --> "0.0.46" 
# code-version-calc "0.0.99" 100 "." # "0.0.99" --> "0.1.0" 
# code-version-calc "0-0-0"  10  "-" # "0-0-0" --> "0-0-1" 
function code-version-calc(){
	#read params
	current_version=$1 limit=$2 delimiter=$3
	# echo " current_version:$current_version"
	# echo " limit:$limit"
	# echo " delimiter:$delimiter"
	#split string current_version into array of values
	IFS="$delimiter"
	read -ra values <<<"$current_version"

	next=1
	CODE_VERSION_NEXT=""
	# parseNumber $(())
	len=$((${#values[@]}-1))
	for (( i=$len; i>=0 ; i-- )) ; do
		v=$((${values[i]}+next))
		if [ $v -ge $limit ];then
			next=1 v=0
		else
			next=0
		fi
		#echo "i:$i len:$len"
		if [ $i -eq $len ];then
			CODE_VERSION_NEXT="$v"
		else
			CODE_VERSION_NEXT="$v$delimiter$CODE_VERSION_NEXT"
		fi
	done
	echo "$current_version --> $CODE_VERSION_NEXT"

}

function code-version-init(){
	CODE_VERSION_DELIMITER="."
	CODE_VERSION_LIMIT=100
	CODE_VERSION="0.0.0"
	ERRORS_READING_PARAMS=""
	#read options
	for i in "$@"
	do

		{ #TRY
			#echo "CHECKING: $i -> \$1=$1 \$=$2"
			# shift allow alway read $1 as argument and $2 as value
			case $i in
				#------------------------------------
				# CODE_VERSION_DELIMITER
				#------------------------------------
				-d|--delimiter) #Space-Separated 
					CODE_VERSION_DELIMITER="$2"
					#echo "space CODE_VERSION_DELIMITER=$CODE_VERSION_DELIMITER"
					shift # past argument
				;;
				-d=*|--delimiter=*) #Equals-Separated 
					CODE_VERSION_DELIMITER="${i#*=}"
					shift # past argument=value
				;;
				#------------------------------------
				# CODE_VERSION_LIMIT
				#------------------------------------
				-l|--limit) #Space-Separated 
					CODE_VERSION_LIMIT="$2"
					shift # past argument
				;;
				-l=*|--limit=*)
					CODE_VERSION_LIMIT="${i#*=}"
					shift # past argument=value
				;;
				#------------------------------------
				# CODE_VERSION
				#------------------------------------
				-v|--version) #Space-Separated 
					CODE_VERSION="$2"
					read_file=false
					#echo "CODE_VERSION: $CODE_VERSION"
					shift # past argument
				;;
				-v=*|--version=*)
					CODE_VERSION="${i#*=}"
					read_file=false
					shift # past argument=value
				;;
				#------------------------------------
				# UNKNOW COMMAND
				#------------------------------------
				*)
					shift # past argument=value
				;;
			esac
			
		} || { #CATCH
			#ERRORS_READING_PARAMS="$ERRORS_READING_PARAMS\nError reading $i:$?"
			echo "$?"
		}
	done
	echo -e "CODE_VERSION_DELIMITER='$CODE_VERSION_DELIMITER'\nCODE_VERSION_LIMIT='$CODE_VERSION_LIMIT'\nCODE_VERSION='$CODE_VERSION'\n" > "$CODE_VERSION_FILE"
	cat $CODE_VERSION_FILE
}
function code-version(){
	save=false
	read_file=true

	# create file .code-version  if not exist or if --init param was given, with first version config
	if [[ ! -f "$CODE_VERSION_FILE"  ||  "$*" == *--init* ]];then
		#echo "code-version-init $@"
		code-version-init $@
	fi

	source $CODE_VERSION_FILE

	#read options
	for i in "$@"
	do

		{ #TRY
			#echo "cheking $i option $1 $2"
			# shift allow alway read $1 as argument and $2 as value
			case $i in
				#------------------------------------
				# STORE
				#------------------------------------
				-s|--save)
					save=true
					shift # past argument=value
				;;
				
				#------------------------------------
				# UNKNOW COMMAND
				#------------------------------------
				*)
					shift # past argument=value
				;;
			esac
			
		} || { #CATCH
			ERRORS_READING_PARAMS="$ERRORS_READING_PARAMS\nError reading $i:$?"
		}
	done


	#calculate next version
	#echo "code-version-calc $CODE_VERSION $CODE_VERSION_LIMIT $CODE_VERSION_DELIMITER"
	code-version-calc "$CODE_VERSION" "$CODE_VERSION_LIMIT" "$CODE_VERSION_DELIMITER"
	#save new version in file
	if [[ "$save" == true ]];then
		#echo "updating version file"
		echo -e "CODE_VERSION_DELIMITER='$CODE_VERSION_DELIMITER'\nCODE_VERSION_LIMIT='$CODE_VERSION_LIMIT'\nCODE_VERSION='$CODE_VERSION_NEXT'\n" > "$CODE_VERSION_FILE"
	fi
	CODE_VERSION=$CODE_VERSION_NEXT
}
#export $(bash -c 'source ./run_version.sh && code-version >> /dev/null && echo "CODE_VERSION=$CODE_VERSION"' | xargs -L 1)
#echo "$@"
#code-version-init -v 
#code-version $@
#export CODE_VERSION
#