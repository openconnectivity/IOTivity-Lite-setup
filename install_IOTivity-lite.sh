#!/bin/bash

#############################
#
# copyright 2018 Open Connectivity Foundation, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#############################

#
# store the current path and go up 1 folder
#
curpwd=`pwd`
cd ..
#
# step 1 : install all essential things to compile the code on a Linux machine
#
sudo apt-get -y install build-essential git libtool \
autoconf valgrind doxygen wget unzip cmake libboost-dev \
libboost-program-options-dev libboost-thread-dev uuid-dev \
libexpat1-dev libglib2.0-dev libsqlite3-dev libcurl4-gnutls-dev
#
# step 2 : clone the code
#
git clone https://github.com/ibraprog/iotivity-lite.git
#
# step 3: get the appropriate tag (if no tag supplied, it is the master)
#
cd iotivity-lite
if [ "$1" != "" ]; then
  echo " ==> checking out $1"
  git checkout $1
else
  echo " ==> iotivity-lite: master"
fi
#
# go back to the original start folder
#
cd $curpwd
