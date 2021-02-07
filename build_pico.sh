#!/bin/bash

name=$1

FILE=./src/
if [ -z "$(ls -A ${FILE})" ] ; then
	if [[ -n "$name" ]]; then
		project_name="$1"
	else
		echo "Please give a project name!"
		exit 1
	fi
	echo "New project build detected, creating a template now..."
	mkdir src
	cp blink.c ./src/
	cd ./src/
	mkdir project_name
	cd ./project_name/
	touch ${project_name}
	cd ../../
else
	echo "Reindexing source files..."
	project_name=$(ls ./src/project_name/)
fi

FILE=./build/

if [ -z "$(ls -A ${FILE})" ] ; then
	mkdir build
else
	echo "found an existing project build folder!"
	echo "Would u like to remove?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) rm -rf ./build/; mkdir build; break;;
			No ) echo "Remove existing build folder skipped!"; break;;
		esac
	done
fi

FILE=./pico-sdk

if [ -z "$(ls -A ${FILE})" ] ; then
	echo "Getting the latest pico-sdk from github..."
	git clone -b master https://github.com/raspberrypi/pico-sdk.git
#	echo "Do you want to install tinyUSB sdk submodule?"
#	select yn in "Yes" "No"; do
#		case $yn in
#			Yes ) cd pico-sdk; git submodule update --init; cd ..; break;;
#			No ) echo "tinyUSB submodule skipped!"; break;;
#		esac
#	done
	cd pico-sdk 
	git submodule update --init
	cd ..
else
	echo "Found and existing pico sdk, skipped downloading..."
fi

export PICO_SDK_PATH=pico-sdk/


FILE=./pico_sdk_import.cmake

if [[ -f "$FILE" ]]; then
	echo "Removed old sdk import"
	rm pico_sdk_import.cmake
fi

cp pico-sdk/external/pico_sdk_import.cmake .

FILE=./CMakeLists.txt

if [[ -f "$FILE" ]]; then
	echo "Removed old CMakeListtxt"
	rm CMakeLists.txt
fi

SRC_PATH=`find ./src/ -name '*.c' -print`

touch CMakeLists.txt

printf "#This is auto-generated cmakefile\r\n
cmake_minimum_required(VERSION 3.13)\r\n
set(project_name ""${project_name})""\r\n
include(pico_sdk_import.cmake)\r\n
project(${project_name})\r\n
pico_sdk_init()\r\n
add_executable(${project_name}\r\n
${SRC_PATH}\r\n
)\r\n
pico_enable_stdio_usb(${project_name} 1)\r\n
pico_enable_stdio_uart(${project_name} 1)\r\n
pico_add_extra_outputs(${project_name})\r\n
target_link_libraries(${project_name} pico_stdlib)\r\n " >> CMakeLists.txt

cp -rf pico-sdk build
cd build

cmake ..
make -j4

FILE=./${project_name}.elf

if [[ -f "$FILE" ]]; then
	printf "Project build is done!
You can manually add more modules to this script if required and re-run again.
if you added new source files to the src folder, re-run this again to refresh the source file indexes.

For normal project compilation, go to build folder and run make command:
cd build
make\n"
else
	echo "Error during project initialization, please check terminal log!"
fi

