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


# create the generation script
echo "#!/bin/bash" > gen.sh
echo "cd DeviceBuilder" >> gen.sh
echo "sh ./DeviceBuilder_IotivityLiteServer.sh ../example.json  ../device_output \"oic.d.light\"" >> gen.sh
echo "cd .." >> gen.sh
echo "# copying source code to compile location" >> gen.sh
echo "cp ./device_output/code/simpleserver.c ./iotivity-constrained/apps/device_builder_server.c " >> gen.sh
echo "if [ ! -f ./iotivity-constrained/apps/simpleserver_windows.c_org ]; then" >> gen.sh
echo "  # keep the original file for the windows solution, but do this only once" >> gen.sh
echo "  cp ./iotivity-constrained/apps/simpleserver_windows.c ./iotivity-constrained/apps/simpleserver_windows.c_org" >> gen.sh
echo "fi" >> gen.sh
echo "# copy over the file of the windows solution" >> gen.sh
echo "cp ./device_output/code/simpleserver.c ./iotivity-constrained/apps/simpleserver_windows.c" >> gen.sh
echo "# copy over the IDD file of the windows solution" >> gen.sh
echo "cp ./device_output/code/server_introspection.dat.h ./iotivity-constrained/include/server_introspection.dat.h " >> gen.sh


# create the build script
echo "#!/bin/bash" > build.sh
echo "cd iotivity-constrained/port/linux/" >> build.sh
echo "#comment out one of the next lines to build another port" >> build.sh
for d in ./iotivity-constrained/port/*/ ; do
    echo "#cd $d" >> build.sh
done
echo "#uncomment next line for building the debug version" >> build.sh
echo "#make -f devbuildmake DYNAMIC=1 DEBUG=1 device_builder_server" >> build.sh
echo "make -f devbuildmake DYNAMIC=1 device_builder_server" >> build.sh
echo "cd ../../.." >> build.sh

# create the edit code script
echo "#!/bin/bash" > edit_code.sh
echo "nano ./iotivity-constrained/apps/device_builder_server.c" >> edit_code.sh

# create the edit input script
echo "#!/bin/bash" > edit_input.sh
echo "nano ./example.json" >> edit_input.sh

# create the run script
echo "#!/bin/bash"> run.sh
echo 'CURPWD=`pwd`'>> run.sh
echo "cd ./iotivity-constrained/port/linux/" >> run.sh
for d in ./iotivity-constrained/port/*/ ; do
    echo "#cd $d" >> run.sh
done
echo "pwd" >> run.sh
echo "ls" >> run.sh
echo "./device_builder_server" >> run.sh
echo 'cd $CURPWD' >> run.sh

# create the reset script
echo "#!/bin/bash"> reset.sh
for d in ./iotivity-constrained/port/*/ ; do
    echo "rm -rf ${d}device_builder_server_creds" >> reset.sh
done
#echo "rm -rf ./iotivity-constrained/port/linux/device_builder_server_creds" >> reset.sh


cd $CURPWD

echo "making the example directory"
#mkdir -p ../iotivity/examples/${code_path}
# add the build file
for d in ../iotivity-constrained/port/*/ ; do
    cp ./environment-changes/devbuildmake ${d}devbuildmake
done


chmod a+x ../*.sh
