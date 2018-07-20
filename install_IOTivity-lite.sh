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

curpwd=`pwd`
cd ..

# step 1
sudo apt-get -y install build-essential git  libtool \
autoconf valgrind doxygen wget unzip cmake uuid-dev \
libexpat1-dev libglib2.0-dev libsqlite3-dev libcurl4-gnutls-dev

# step 2
#git clone https://gerrit.iotivity.org/gerrit/iotivity-constrained
git clone https://github.com/iotivity/iotivity-constrained.git
mv -f iotivity-constrained iotivity-lite

#cd iotivity
#git checkout 1.3-rel



cd $curpwd