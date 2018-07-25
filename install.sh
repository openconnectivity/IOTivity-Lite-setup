#!/bin/bash
set -x #echo on
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

mkdir iot-lite
cd iot-lite
# system update
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y update
# make sure that git is there, because the scripts are using git.
# nano and automake are needed for artik boards
sudo apt-get -y install git nano automake 

#install_IOTivity-lite.sh
git clone https://github.com/openconnectivity/IOTivity-Lite-setup.git
cd IOTivity-Lite-setup
sh install_IOTivity-lite.sh
sh install_DeviceBuilder.sh