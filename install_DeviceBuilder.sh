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
CURPWD=`pwd`

#path of the code
code_path=OCFDeviceBuilder

# linux pi
# default
ARCH=`uname -m`

echo "using architecture: $ARCH"

cd ..
# clone the repo
git clone https://github.com/openconnectivityfoundation/DeviceBuilder.git
# get the initial example 
cp DeviceBuilder/DeviceBuilderInputFormat-file-examples/input-lightdevice.json example.json

# clone the iotivity cbor conversion tool 
git clone https://github.com/alshafi/iotivity-tool.git
# install the python libraries that are needed for iotivity-tool
cd iotivity-tool
pip3 install -U -r requirements.txt

# create the initial security file and place it in the code directory.
cd $CURPWD
sh svr2cbor.sh tocbor
cd ..

# create the generation script
echo "#!/bin/bash" > gen.sh
echo "cd DeviceBuilder" >> gen.sh
echo "sh ./DeviceBuilder_C++IotivityServer.sh ../example.json  ../device_output \"oic.d.light\"" >> gen.sh
echo "cd .." >> gen.sh
echo "# copying source code to compile location" >> gen.sh
echo "cp ./device_output/code/server.cpp ./iotivity/examples/${code_path}/server.cpp " >> gen.sh
echo "# making executable folder"  >> gen.sh
echo "mkdir -p ./iotivity/out/linux/${ARCH}/release/examples/${code_path} >/dev/null 2>&1" >> gen.sh
echo "# copying the introspection file to the executable folder" >> gen.sh
echo "cp ./device_output/code/server_introspection.dat ./iotivity/out/linux/${ARCH}/release/examples/${code_path}/server_introspection.dat" >> gen.sh
echo "# quick fix: using the iotivity supplied oic_svr_db_server_justworks.dat file" >> gen.sh
# working copy line of clarke
# copying the file so that reset.sh works
#cp  ~/iot/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ~/iot/device_output/code/server_security.dat
echo "cp ./iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat     ./device_output/code/server_security.dat"
# working copy line from clarke :
#  cp ~/IOT/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ~/IOT/iotivity/out/linux/armv7l/release/examples/OCFDeviceBuilder/server_security.dat
echo "cp ./iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat     ./iotivity/out/linux/${ARCH}/release/examples/${code_path}/server_security.dat" >> gen.sh
#echo "cp ./device_output/code/server_security.dat  ./iotivity/out/linux/${ARCH}/release/examples/${code_path}/server_security.dat" >> gen.sh


# create the build script
echo "#!/bin/bash" > build.sh
echo "cd iotivity" >> build.sh
echo "#uncomment next line for building without security" >> build.sh
echo "#scons examples/${code_path} SECURED=0" >> build.sh
echo "scons examples/${code_path}" >> build.sh
echo "cd .." >> build.sh

# create the edit script
echo "#!/bin/bash" > edit_code.sh
echo "nano ./iotivity/examples/${code_path}/server.cpp" >> edit_code.sh

# create the run script
echo "#!/bin/bash"> run.sh
echo 'CURPWD=`pwd`'>> run.sh
#echo 'CURPWD=$(pwd -P)'>> run.sh
echo "env LD_LIBRARY_PATH=${CURPWD}/mraa/build/src" >> run.sh
echo "sudo ldconfig" >> run.sh
echo "cd ./iotivity/out/linux/${ARCH}/release/examples/${code_path}" >> run.sh
echo "pwd" >> run.sh
echo "ls" >> run.sh
echo "./server" >> run.sh
echo 'cd $CURPWD' >> run.sh

# create the reset script
echo "#!/bin/bash"> reset.sh
echo "mkdir -p ./iotivity/out/linux/${ARCH}/release/examples/${code_path} >/dev/null 2>&1" >> reset.sh
echo "rm -f ./iotivity/out/linux/${ARCH}/release/examples/${code_path}/server_security.dat" >> reset.sh
echo "#cp ./device_output/code/server_security.dat ./iotivity/out/linux/${ARCH}/release/examples/${code_path}/server_security.dat" >> reset.sh
echo "cp ./iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ./iotivity/out/linux/${ARCH}/release/examples/${code_path}/server_security.dat" >> reset.sh


cd $CURPWD

echo "making the example directory"
mkdir -p ../iotivity/examples/${code_path}
# add the build file
cp ./SConscript ../iotivity/examples/${code_path}/SConscript 
# add the build dir
cp ./SConstruct ../iotivity/.



chmod a+x ../*.sh