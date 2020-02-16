#!/bin/bash

# Xbuilder library source file
# This library is for including by other bash scripts

# Copyright (C) 2019 Grzegorz Kociołek (Dark565)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


##################################################################################
# Symbols:
#
#	> 'PRIVATE:' 	- Code below this statement is for use only by xbuilder.
#			  Changing private variables may bring unexpected behavior!
#
#	> '__*' 	- Variable or function is private
#	> XBUILDER_*	- Xbuilder variable
#	> xbuilder__*	- Xbuilder function
##################################################################################

# XBUILDER_PROGRESS_WIDTH - Width of the progress bar
###################################################
# PRIVATE:
# __XBUILDER_FILES_COUNT - Count of files
###################################################
function __xbuilder__compile_receiver() {
	# Print status

	function __xbuilder__compile_receiver_interrupt() {
		echo -e "\n\n-- Compiling has been interrupted! --"
		exit 1
	}

	trap '__xbuilder__compile_receiver_interrupt' SIGINT SIGTERM

	local COUNT
	local STATUS
	local STAT
	local FILE
	local RETVAL
	local PROGRESS_NUM

	local CMP_THREAD_ID

	local TIME_NOW=0
	local TIME_THEN=0

	local CUR_TIMESTAMP=0

	local THR_TBEG
	local THR_TNOW
	local THR_TIMESTAMP

	local TIMESTAMP_IT

	local AVG_TIMESTAMP=0
	local AVG_FREQ=0
	local AVG_EST=0

	local TH_NUM=1
	local DIVIDER=$((XBUILDER_THREADS))

	printf -- "-- Compilation with '${__XBUILDER_COMPILER}' -- Started at: "; date
	echo

	COUNT=1
	while [[ ${COUNT} -le ${__XBUILDER_FILES_COUNT} ]]; do


		if ! read -r STATUS; then
			retval=1
			break
		fi

		STAT="${STATUS:0:1}"
		FILE="${STATUS:1}"
		FILE="${STATUS#*|}"
		CMP_THREAD_ID=${STATUS:1}
		CMP_THREAD_ID=${CMP_THREAD_ID%%\|*}

		if [[ ${STAT} == '3' ]]; then
			unset THR_NOW[CMP_THREAD_ID]
			unset THR_BEG[CMP_THREAD_ID]
			unset THR_TIMESTAMP[CMP_THREAD_ID]
		else

			THR_TNOW[CMP_THREAD_ID]=${EPOCHREALTIME/.}

			if [[ -z ${THR_TBEG[CMP_THREAD_ID]} ]]; then
				THR_TBEG[CMP_THREAD_ID]=${THR_TNOW[CMP_THREAD_ID]}
			fi

			THR_TIMESTAMP[CMP_THREAD_ID]=$((${THR_TNOW[CMP_THREAD_ID]}-${THR_TBEG[CMP_THREAD_ID]}))

			THR_TBEG[CMP_THREAD_ID]="${THR_TNOW[CMP_THREAD_ID]}"

			AVG_TIMESTAMP=0

			for TIMESTAMP_IT in ${THR_TIMESTAMP[@]}; do
				(( AVG_TIMESTAMP+=TIMESTAMP_IT ))
			done

			(( AVG_TIMESTAMP/=$((${#THR_TIMESTAMP[@]}**2)) ))

			if [[ ${AVG_TIMESTAMP} == 0 ]]; then
				AVG_FREQ='∞'
			else
				AVG_FREQ=$((1000000/AVG_TIMESTAMP))
			fi
			AVG_EST=$((AVG_TIMESTAMP*(__XBUILDER_FILES_COUNT-COUNT)/1000000))
		fi

		#printf "\x1b[1A\r"

		if [[ ${STAT} == '2' ]]; then
			printf -- "-- Fatal error occured in '$FILE'! --\x1b[K\n"
			RETVAL=1
			STAT=0
		fi

		[[ ${STAT} == '1' ]] && STAT="✓" || STAT="x"
		PROGRESS_NUM=$((COUNT*XBUILDER_PROGRESS_WIDTH/__XBUILDER_FILES_COUNT))
		printf "[${__XBUILDER_COMPILER}] - ${COUNT}/${__XBUILDER_FILES_COUNT} - '$FILE' - $STAT\x1b[K\n"

		# Progress bar
		printf "[";
		for ((i=0; i<${PROGRESS_NUM}; i++)); do
			printf '-'
		done
		printf "\x1b[$((XBUILDER_PROGRESS_WIDTH-PROGRESS_NUM))C]"
		printf " ${AVG_FREQ} files/s, estimated time: ${AVG_EST} seconds\x1b[K\x1b[1A\r"

		((COUNT++))
	done

	printf "\n\n"
	return $RETVAL

}
###################################################


# Get first free file descriptor for the current shell process
function xbuilder__get_free_fd() {
	find /proc/${BASHPID}/fd/ | \
	sort -n | \
	tail -n1 | \
	sed 's/.*\///' | \
	awk '{printf("%i\n",$1+1)}'
}

# $1 - variable
# $2 - default value
function xbuilder__check_variable() {
	if eval "[[ -z \$$1 ]]"; then
		printf "'$1' not specified. " >&2
		if [[ -n "$2" ]]; then
			printf "Default value is: '$2'" >&2
			eval "$1=\"$2\""
		fi
		printf "\n"
	fi
}

function xbuilder__check_variable_quiet() {
	xbuilder__check_variable "$1" "$2" 2>/dev/null
}

# $1 - list name
function xbuilder__check_list() {
	if eval "[[ -z \${$1[@]} ]]"; then
		echo "Error! List $1 is empty." >&2
		return 1
	fi
}

# $1 - variable
# $2 - old text
# $3 - new text
function xbuilder__replace_hard() {
	eval "$1=\${$1//\$2/\$3}"
}

# Unset all private variables
function xbuilder__cleanup() {
	unset __XBUILDER_STATUS_FUNCTION
	unset __XBUILDER_PARENT_PID
	unset __XBUILDER_FILES_COUNT
}

# Unset all global builder variagbles
function xbuilder__unset_variables() {
	unset XBUILDER_CMP
	unset XBUILDER_CMP_FLAGS
	unset XBUILDER_FILES
	unset XBUILDER_OUTEXT
	unset XBUILDER_BUILD_DIR
	unset XBUILDER_THREADS
	unset XBUILDER_STATUS
	unset XBUILDER_DIRDELIM
	unset XBUILDER_TERM_FATAL
}

# Unsource the xbuilder
function xbuilder__unset_functions() {
	# Control functions #
	unset -f __xbuilder__compile_receiver
	unset -f xbuilder__get_free_fd
	unset -f xbuilder__check_variable
	unset -f xbuilder__check_variable_quiet
	unset -f xbuilder__check_list
	unset -f xbuilder__cleanup
	unset -f xbuilder__replace_hard
	unset -f xbuilder__unset_variables
	unset -f xbuilder__unset_functions
	unset -f xbuilder__unsource
	unset -f xbuilder__resource
	unset -f xbuilder__install
	unset -f xbuilder__get_source_file
	unset -f xbuilder__is_sourced
	unset -f xbuilder__get_version
	unset -f xbuilder__help

	# Building functions #
	unset -f xbuilder__compile
	unset -f xbuilder__chg_extensions
	unset -f xbuilder__link
	unset -f xbuilder__match_files
	unset -f xbuilder__compile_dir
	unset -f xbuilder__link_dir
	unset -f xbuilder__cd_to_gitroot
}

function xbuilder__unsource() {
	# Variables
	xbuilder__cleanup
	xbuilder__unset_variables

	# Functions
	xbuilder__unset_functions
}

# Compile files to specified to object files
# XBUILDER_CMP - A compiler
# XBUILDER_CMP_FLAGS - Compiler flags
# XBUILDER_FILES - List of files to compile
# XBUILDER_OUTEXT - Extension of an output file
# XBUILDER_BUILD_DIR - A build directory
# XBUILDER_THREADS - Count of working threads (0 or less indicates for builder to choose a number of system logical CPUs)
# XBUILDER_STATUS [=1/0] - Print status of compiling
# XBUILDER_TERM_FATAL [=1/0] - Stop compilation on fatal error
# XBUILDER_DIRDELIM - Delimiter of directory and a file for output. (ex. for delimiter: '%', dir/a.c is compiled to build/dir%a.o)
#		If delimiter is not specified, a directory of a source file is not included in the output
# Optional:
# XBUILDER_PROGRESS_WIDTH - Width in characters of progress bar printed if XBUILDER_STATUS was set to 1. Defaultly 10
#######################
# PRIVATE:
# __XBUILDER_STATUS_FUNCTION - Generally, it isn't for changing, but this variable points to a function which receives communicates about compilation
#			Defaultly it is __xbuilder__compile_receiver
# __XBUILDER_PARENT_PID - PID of a process which will be signalled with SIGINT on fatal error
# __XBUILDER_THREAD_ID - ID of current working thread
#######################
function xbuilder__compile() {
xbuilder__check_variable_quiet __XBUILDER_STATUS_FUNCTION __xbuilder__compile_receiver
# Check variables
xbuilder__check_list 	 XBUILDER_FILES || return 1
xbuilder__check_variable XBUILDER_CMP 		cc
xbuilder__check_variable XBUILDER_CMP_FLAGS	-c
xbuilder__check_variable XBUILDER_BUILD_DIR	./
xbuilder__check_variable XBUILDER_THREADS	0
xbuilder__check_variable XBUILDER_STATUS	0
xbuilder__check_variable XBUILDER_OUTEXT	.o
xbuilder__check_variable_quiet XBUILDER_PROGRESS_WIDTH 10


# Configure XBUILDER_THREADS variable
if [[ ${XBUILDER_THREADS} -le 0 ]]; then
	XBUILDER_THREADS=$(($(find /sys/bus/cpu/devices/ -maxdepth 1 | wc -l)-1)) 	# Don't worry if you compile on Windows.
											# Here you also have /sys directory, 
											# because you probably use WSL, Msys2 or Cygwin to compile.
	[[ ${XBUILDER_THREADS} -eq 0 ]] && XBUILDER_THREADS=1
fi

local compiler_receiver
local stdout_dump_fd
if [[ ${XBUILDER_STATUS} == 1 ]]; then
	compile_receiver=${__XBUILDER_STATUS_FUNCTION}
else
	compile_receiver=
	if [[ -n ${__XBUILDER_PARENT_PID} ]]; then
		#stdout_dump_fd=$(xbuilder__get_free_fd)
		#eval "exec ${stdout_dump_fd}>&1"
		exec 10>&1
	fi
fi

{
	jobs -p >&2

	function __local__xbuilder__cleanup() {
		kill -s SIGINT $(jobs -p) ${__XBUILDER_PARENT_PID}
		exit $1
	}

	
	exec 1>&10

	#if [[ -n ${stdout_dump_fd} ]]; then
	#	#exec 1>&${stdout_dump_fd}
	#	exec 1>&10
	#fi

	# Register a trap for cleaning
	trap '__local__xbuilder__cleanup 1;' SIGINT SIGTERM

	xbuilder__check_variable_quiet __XBUILDER_THREAD_ID 0

	# Define local variables
	local file
	local thread
	local format_dir
	local out_base
	local to_print
	local currpid="${BASHPID}"

	# Create a build directory
	mkdir -p "${XBUILDER_BUILD_DIR}"
	
	# Divide files between threads
	local thread_division=$((${#XBUILDER_FILES[@]}/XBUILDER_THREADS))
	local thread_rest=$((${#XBUILDER_FILES[@]}%XBUILDER_THREADS))
	local thread_add_rest
	local thread_add_count

	if [[ $thread_division == 0 ]]; then
		thread_division=1
		XBUILDER_THREADS=$thread_rest
	fi

	# Make threads
	if [[ ${XBUILDER_THREADS} -gt 1 ]]; then

		if [[ ${thread_division} -gt 0 ]]; then
			for ((thread=1; thread<${XBUILDER_THREADS}; thread++)); do
				thread_add_rest=$((thread_rest-- > 0))
				thread_add_count=$((thread_add_rest+thread_division))
				{
					__XBUILDER_PARENT_PID=${currpid}
					(( __XBUILDER_THREAD_ID+=thread ))
					XBUILDER_STATUS=0
					XBUILDER_THREADS=1
					XBUILDER_FILES=( "${XBUILDER_FILES[@]:0:thread_add_count}" )
					xbuilder__compile
				} &
				XBUILDER_FILES=( "${XBUILDER_FILES[@]:thread_add_count:${#XBUILDER_FILES[@]}-thread_add_count}" )
			done
		fi
	fi

	# Do the rest of the work on a current thread
	for file in "${XBUILDER_FILES[@]}"; do
		out_base="${file%/}"
		out_base="${out_base##*/}"
		out_base="${out_base%.*}${XBUILDER_OUTEXT}"

		if [[ -n $XBUILDER_DIRDELIM ]]; then

			format_dir="${file%/}"
			format_dir="${format_dir%/*}/"
			format_dir="${format_dir//${XBUILDER_DIRDELIM}/${XBUILDER_DIRDELIM}${XBUILDER_DIRDELIM}}"
			format_dir="${format_dir//\//${XBUILDER_DIRDELIM}}"

			# Second method of above, but much slower.
			# Forking and executing takes some time.
			# The uncommented method does everything natively.
			#format_dir="$(sed  	-e 's/\/.*$/\//' \
			#			-e 's/'"${XBUILDER_DIRDELIM}"'/'"${XBUILDER_DIRDELIM}${XBUILDER_DIRDELIM}"'/g' \
			#			-e 's/\//'"${XBUILDER_DIRDELIM}"'/g' <<< "${file}")"

			out_base="${format_dir}${out_base}"
		fi

		if "${XBUILDER_CMP}" -o "${XBUILDER_BUILD_DIR}/${out_base}" "${file}" ${XBUILDER_CMP_FLAGS} >&2; then
			to_print='1'
		else
			if [[ $XBUILDER_TERM_FATAL == 1 ]]; then
				to_print='2'
			else
				to_print='0'
			fi
		fi
				
		# Wipe out new line characters from a file name so a pipe can get valid file name
		file="${file//$'\n'/\$\'\\n\'}"
		echo "${to_print}${__XBUILDER_THREAD_ID}|${file}"

		if [[ ${to_print} == '2' ]]; then
			__local__xbuilder__cleanup 1
		fi
	done

	echo "3${__XBUILDER_THREAD_ID}"

	# Wait for all threads to exit
	wait
} | \
__XBUILDER_FILES_COUNT=${#XBUILDER_FILES[@]} \
__XBUILDER_COMPILER=${XBUILDER_CMP} \
XBUILDER_PROGRESS_WIDTH=${XBUILDER_PROGRESS_WIDTH} \
XBUILDER_THREADS=${XBUILDER_THREADS} \
${compile_receiver}
#echo "${stdout_dump_fd}" 1>&0
#eval "exec ${stdout_dump_fd}>&-"
exec 10>&-
}


# Change extensions of files in a list
# XBUILDER_FILES - List of files
# XBUILDER_EXT_PREV - Previous extension
# XBUILDER_EXT_NEXT - Extension to which we want to replace suffixes
function xbuilder__chg_extensions() {
	xbuilder__check_list XBUILDER_FILES 		|| return 1
	xbuilder__check_variable XBUILDER_EXT_PREV	|| return 1
	xbuilder__check_variable XBUILDER_EXT_NEXT	|| return 1

	XBUILDER_FILES=( "${XBUILDER_FILES[@]/${XBUILDER_EXT_PREV}/${XBUILDER_EXT_NEXT}}" )
}

# Link files to specified output
# XBUILDER_LNK - A linker
# XBUILDER_LNK_FLAGS - Linker flags
# XBUILDER_FILES - Array of files to link
# XBUILDER_OUTPUT - File to which we want to link
# XBUILDER_BUILD_DIR - A build directory
# XBUILDER_STATUS [=1/0] - Print status of linking
function xbuilder__link() {
	local retval
	local msg
	xbuilder__check_list	 XBUILDER_FILES		|| return 1
	xbuilder__check_variable XBUILDER_LNK		cc
	xbuilder__check_variable XBUILDER_OUTPUT 	a.out
	xbuilder__check_variable XBUILDER_BUILD_DIR	./
	xbuilder__check_variable XBUILDER_STATUS	0

	"${XBUILDER_LNK}" -o "${XBUILDER_BUILD_DIR}/${XBUILDER_OUTPUT}" "${XBUILDER_FILES}" ${XBUILDER_LNK_FLAGS}
	retval=$?

	if [[ ${XBUILDER_STATUS} == 1 ]]; then
		[[ ${retval} -eq 0 ]] && msg="successfully" || msg="with a fail"
		echo "[${XBUILDER_LNK}] ${XBUILDER_BUILD_DIR}/${XBUILDER_OUTPUT} linked ${msg}!"
	fi
}

# Get files of specified extension in specified directory
# XBUILDER_SPECDIR
# XBUILDER_DIRDEPTH
# XBUILDER_EXTENSTIONS
function xbuilder__match_files() {
	xbuilder__check_variable XBUILDER_SPECDIR	./
	xbuilder__check_variable XBUILDER_DIRDEPTH	1
	xbuilder__check_variable XBUILDER_EXTENSIONS 	|| return 1

	local files="$(find "${XBUILDER_SPECDIR}" \
				-maxdepth ${XBUILDER_DIRDEPTH} \
				-regex ".*\\($(sed 's/,/\\|/g' <<< "${XBUILDER_EXTENSTIONS}")\\)$" \
				-type f -o -type l \
			| \
			sed -e 's/^\.\///' -e 's/\(.*\)/'\''\1'\''/')"

	eval "XBUILDER_FILES=("${files}")"
}

# Compile a specified directory
# Variables the same as in xbuilder__compile, excluding XBUILDER_FILES
# Variables the same as in xbuilder__match_files
function xbuilder__compile_dir() {
	xbuilder__check_variable XBUILDER_SPECDIR	./
	xbuilder__check_variable XBUILDER_DIRDEPTH	1
	xbuilder__check_variable XBUILDER_EXTENSIONS	.c

	xbuilder__match_files && { xbuilder__compile; true; } || { echo "Cannot match files in specified directory" >&2; return 1; }
}

# Link files in a specified directory
# Variables the same as in xbuilder__link, excluding FILES, and additionally with
# XBUILDER_SPECDIR - A specified directory
# XBUILDER_DIRDEPTH - How deep this function has to look for files
# XBUILDER_EXTENSTION - Extenstion of files going to compile
function xbuilder__link_dir() {
	xbuilder__check_variable XBUILDER_SPECDIR	./
	xbuilder__check_variable XBUILDER_DIRDEPTH	1
	xbuilder__check_variable XBUILDER_EXTENSIONS	.o

	xbuilder__match_files && { xbuilder__link; true; } || { echo "Cannot match files in specified directory" >&2; return 1; }
}

# Cd to the project root repository (directory having at least .git).
# XBUILDER_SHOULDHAVE - List of elements Aqua root directory must have
function xbuilder__cd_to_gitroot() {
	local CPWD
	local elem
	local SKIP

	CPWD="$PWD"
	while true; do
		for elem in ".git" "${XBUILDER_SHOULDHAVE[@]}"; do
			if ! [[ -e "$elem" ]]; then
				if [[ $PWD == '/' ]] || ! cd ..; then
					cd "$CPWD"
					return 1
				fi

				CONT=1
				break
			fi
			CONT=
				
		done
		if [[ -z $CONT ]]; then
			break
		fi
	done

	return 0
}


# Get the sourced xbuilder file
function xbuilder__get_source_file() {

	local sourcename
	if [[ -z ${__XBUILDER_SOURCE_PATH} ]]; then
		sourcename="${BASH_SOURCE[${FUNCNAME[0]}]}"

		if [[ ${sourcename} == $0 ]]; then
			return 1
		else
			__XBUILDER_SOURCE_PATH="$(readlink -f "${sourcename}")"
		fi
	fi
	echo "${__XBUILDER_SOURCE_PATH}"
}

# Check whether script was sourced
function xbuilder__is_sourced() {
	xbuilder__get_source_file >/dev/null
}

# Source the xbuilder again
function xbuilder__resource() {
	source "$(xbuilder__get_source_file)"
}
# This function is used to install the xbuilder into /usr/bin
# If you want to install it, simply do:
# $ su
# $ source <PATH TO builder.sh>
# $ xbuilder__install
# Instead of `source` command, you can use one-character `.` instruction,
# which is definitively the same.
# To source it later, simply write
# $ source xbuilder.sh
# Variables:
#  XBUILDER_INSTALL_DIR
function xbuilder__install() {
	xbuilder__check_variable_quiet XBUILDER_INSTALL_DIR /usr/bin

	local THIS_SOURCE_PATH="$(xbuilder__get_source_file)"

	if [[ -z ${THIS_SOURCE_PATH} ]]; then
		echo "Cannot locate Xbuilder source file. Was it really sourced?"
		return 1
	fi

	install "${THIS_SOURCE_PATH}" "${XBUILDER_INSTALL_DIR}/xbuilder.sh" \
	&& { echo -e "\n--- 'xbuilder.sh' has been successfully installed! ---"; return 0; }\
	|| { echo -e "\n--- An error occured when trying to install 'xbuilder.sh' ---"; return 1; }
}

# Print version of the xbuilder
function xbuilder__get_version() {
	echo "1.0"
}

# Print help
function xbuilder__help() {
xbuilder__get_source_file >/dev/null
[[ -n ${__XBUILDER_SOURCE_PATH} ]] && sourcepath="${__XBUILDER_SOURCE_PATH}" || sourcepath="-"
echo \
" xbuilder is a build system written in bash.
It is written as one .sh file which is later sourced by other scripts.
How would say - it is a shared library.


xbuilder defines following functions:

- xbuilder__compile();
Compile specific files into object files.
Variables:
 XBUILDER_CMP - A compiler
 XBUILDER_CMP_FLAGS - Compiler flags
 XBUILDER_FILES - List of files to compile
 XBUILDER_OUTEXT - Extension of an output file
 XBUILDER_BUILD_DIR - A build directory
 XBUILDER_THREADS - Count of working threads (0 or less indicates for builder to choose a number of system logical CPUs)
 XBUILDER_STATUS [=1/0] - Print status of compiling
 XBUILDER_TERM_FATAL [=1/0] - Stop compilation on fatal error
 XBUILDER_DIRDELIM - Delimiter of directory and a file for output. (ex. for delimiter: '%', dir/a.c is compiled to build/dir%a.o)
		If delimiter is not specified, a directory of a source file is not included in the output

- xbuilder__chg_extensions();
Change extensions of the names in list XBUILDER_FILES
Variables:
 XBUILDER_FILES - List of files
 XBUILDER_EXT_PREV - Previous extension
 XBUILDER_EXT_NEXT - Extension to which we want to replace suffixes

- xbuilder__link();
Link specific files into binary file.
Variables:
 XBUILDER_LNK - A linker
 XBUILDER_LNK_FLAGS - Linker flags
 XBUILDER_FILES - Array of files to link
 XBUILDER_OUTPUT - File to which we want to link
 XBUILDER_BUILD_DIR - A build directory
 XBUILDER_STATUS [=1/0] - Print status of linking

- xbuilder__compile_dir();
Compile files in specific directory.
Variables:
 Variables the same as in xbuilder__compile, excluding XBUILDER_FILES, and additionally with
 XBUILDER_SPECDIR - A specified directory
 XBUILDER_DIRDEPTH - How deep this function has to look for files
 XBUILDER_EXTENSTIONS - Extensions of files going to compile

- xbuilder__link_dir();
Link files in specific directory.
Variables:
 Variables the same as in xbuilder__link, excluding XBUILDER_FILES, and additionally with
 XBUILDER_SPECDIR - A specified directory
 XBUILDER_DIRDEPTH - How deep this function has to look for files
 XBUILDER_EXTENSTION - Extenstion of files going to compile

- xbuilder__cd_to_gitroot();
Turn back in the directory tree until at least '.git' will be in a directory
Variables:
 XBUILDER_SHOULDHAVE - List of elements, that project root directory must have


xbuilder defines also these control functions:

- xbuilder__resource();
Source xbuilder again.

- xbuilder__unsource();
Unsource the xbuilder

- xbuilder__install();
Install the xbuilder to (defaultly) /usr/bin

- xbuilder__get_free_fd();
Get free file descriptor for the current shell.

- xbuilder__get_source_file();
Get the file from which a source of xbuilder was loaded.

- xbuilder__is_sourced();
Check whether xbuilder was sourced.

- xbuilder__get_version();
Get the version of sourced xbuilder.

- xbuilder__help();
Print this help.

Version: $(xbuilder__get_version)
Sourced from: ${sourcepath}
"

}

# Print help if script wasn't sourced
if ! xbuilder__is_sourced; then
	xbuilder__help >&2
	echo -e "\n--- Script wasn't sourced. ---"
	exit 1
fi
