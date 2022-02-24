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

#
# store the current path and go up 1 folder
#
CURPWD=`pwd`
#
#path of the code
#
code_path=OCFDeviceBuilder
# checking the architecture of the device that is being used to run the script
# linux pi
# default
ARCH=`uname -m`

echo "using architecture: $ARCH"

#
# go one folder up, so that the repo is placed on the same level
#
cd ..
#
# clone the repo of Device Builder
#
git clone https://github.com/ibraprog/DeviceBuilder.git
#
# get the initial example from the repo, and put it on the top level folder
#
cp DeviceBuilder/DeviceBuilderInputFormat-file-examples/input-lightdevice.json example.json

#
# create the generation script, on the top level folder
#
echo "#!/bin/bash" > gen.sh
echo "cd DeviceBuilder" >> gen.sh
echo "# next line is for a generated MQTT server" >> gen.sh
echo "#sh ./DeviceBuilder_mqtt_paho_python.sh ../example.json  ../device_output \"oic.d.light\" $1" >> gen.sh
echo "sh ./DeviceBuilder_IotivityLiteServer.sh ../example.json  ../device_output \"oic.d.light\" $1" >> gen.sh
echo "cd .." >> gen.sh
echo "#" >> gen.sh
echo "# copying source code to compile location (linux)" >> gen.sh
echo "if [ ! -f ./iotivity-lite/apps/device_builder_server.c_org ]; then" >> gen.sh
echo "  # keep the original file for the windows solution, but do this only once" >> gen.sh
echo "  cp ./iotivity-lite/apps/device_builder_server.c ./iotivity-lite/apps/device_builder_server.c_org" >> gen.sh
echo "fi" >> gen.sh
echo "cp ./device_output/code/simpleserver.c ./iotivity-lite/apps/device_builder_server.c " >> gen.sh
echo "#" >> gen.sh
echo "# copying source code to compile location (windows)" >> gen.sh
echo "if [ ! -f ./iotivity-lite/apps/simpleserver_windows.c_org ]; then" >> gen.sh
echo "  # keep the original file for the windows solution, but do this only once" >> gen.sh
echo "  cp ./iotivity-lite/apps/simpleserver_windows.c ./iotivity-lite/apps/simpleserver_windows.c_org" >> gen.sh
echo "fi" >> gen.sh
echo "cp ./device_output/code/simpleserver.c ./iotivity-lite/apps/simpleserver_windows.c" >> gen.sh
echo "#" >> gen.sh
echo "# copying source code to compile location cloud(windows)" >> gen.sh
echo "if [ ! -f ./iotivity-lite/apps/cloud_server.c_org ]; then" >> gen.sh
echo "  # keep the original file for the windows solution, but do this only once" >> gen.sh
echo "  cp ./iotivity-lite/apps/cloud_server.c ./iotivity-lite/apps/cloud_server.c_org" >> gen.sh
echo "fi" >> gen.sh
echo "cp ./device_output/code/simpleserver.c ./iotivity-lite/apps/cloud_server.c" >> gen.sh
echo "#" >> gen.sh
echo "# copy over the IDD header file of the windows solution" >> gen.sh
echo "if [ ! -f ./iotivity-lite/include/server_introspection.dat.h_org ]; then" >> gen.sh
echo "  # keep the original IDD header file, but do this only once" >> gen.sh
echo "  cp ./iotivity-lite/include/server_introspection.dat.h ./iotivity-lite/include/server_introspection.dat.h_org" >> gen.sh
echo "fi" >> gen.sh
echo "cp ./device_output/code/server_introspection.dat.h ./iotivity-lite/include/server_introspection.dat.h " >> gen.sh
echo "# copy over the IDD data file in the windows solution folder" >> gen.sh
echo "# mkdir x86/debug & release solution folder" >> gen.sh
echo "mkdir -p ./iotivity-lite/port/windows/vs2015/x64/Debug" >> gen.sh
echo "mkdir -p ./iotivity-lite/port/windows/vs2015/x64/Release" >> gen.sh
echo "cp ./device_output/code/server_introspection.dat ./iotivity-lite/port/windows/vs2015/x64/Debug/server_introspection.cbor" >> gen.sh
echo "cp ./device_output/code/server_introspection.dat ./iotivity-lite/port/windows/vs2015/x64/Release/server_introspection.cbor" >> gen.sh
echo "cp ./device_output/code/server_introspection.dat ./iotivity-lite/port/linux/server_introspection.cbor" >> gen.sh
echo "#" >> gen.sh
echo "# create the pki include file (if it does not exist)" >> gen.sh
echo "if [ ! -f ./pki_certs.zip ]; then" >> gen.sh
echo "# only create when the file does not exist" >> gen.sh
echo "#sh ./pki.sh " >> gen.sh
echo "sh ./pki.sh" >> gen.sh
echo "echo \" \" ">> gen.sh
echo "fi"  >> gen.sh
#
# create the pki generation script, on the top level folder
#
echo "#!/bin/bash" > pki.sh
echo "# website: https://pki.openconnectivity.org/ocfTestCerts/" >> pki.sh
echo "# command to create the PKI zip file :" >> pki.sh
echo "# curl -d \"cn=Common Name&org=Member Organization&major=2&minor=0&build=1&baseline0=off&black0=on&blue0=on&purple0=on&devName=Device Name&devMfr=Device Manufacturer&ianaPen=IANA Pen&model=CPL Model&version=CPL Version&secureBoot=off&hardwareStorage=on&mudUrl=https://www.domain.tld/resource\" -X POST https://pki.openconnectivity.org/ocfTestCerts/generateTestCert.jsp > CommonName.zip" >> pki.sh
echo "# Legend:" >> pki.sh
echo "#   SubjectDN fields (required)" >> pki.sh
echo "#           n=Common Name&org=Member Organization" >> pki.sh
echo "#   OCF Compliance extension fields" >> pki.sh
echo "#          major=2&minor=0&build=1&baseline0=off&black0=on&blue0=on&purple0=on&devName=Device Name&devMfr=Device Manufacturer " >> pki.sh
echo "#   OCF CPL Attributes extension fields" >> pki.sh
echo "#         ianaPen=IANA Pen&model=CPL Model&version=CPL Version" >> pki.sh
echo "#   OCF Security Claims fields" >> pki.sh
echo "#         secureBoot=off&hardwareStorage=on" >> pki.sh
echo "#   Manufacturer Usage Description" >> pki.sh
echo "#         mudUrl=https://www.domain.tld/resource" >> pki.sh
echo "echo \"Retrieving Kyrio Test Certificate\"" >> pki.sh
echo "# website: https://testcerts.kyrio.com/certificates " >> pki.sh
echo "# command to create the PKI zip file :" >> pki.sh
echo "#curl 'https://testcerts.kyrio.com/certificates' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Origin: https://testcerts.kyrio.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,es;q=0.8,fr-FR;q=0.7,fr;q=0.6,de;q=0.5'  -H 'Content-Type: application/json' -H 'Accept: application/json, text/plain, */*' -H 'Referer: https://testcerts.kyrio.com/' -H 'DNT: 1' --data-binary '{\"device\":{\"manufacturer\":\"CableLabs\",\"name\":\"TestDevice\"},\"subject\":\"testdevice.cablelabs.com\",\"sizeCategory\":\"SMALL\",\"OCFVersionCompliance\":\"2.0.0\"}' --compressed" >> pki.sh
echo "# Legend:" >> pki.sh
echo "#   SubjectDN fields (required)" >> pki.sh
echo "#           n=Common Name&org=Member Organization" >> pki.sh
echo "#   OCF Compliance extension fields" >> pki.sh
echo "#          major=2&minor=0&build=1&baseline0=off&black0=on&blue0=on&purple0=on&devName=Device Name&devMfr=Device Manufacturer " >> pki.sh
echo "#   OCF CPL Attributes extension fields" >> pki.sh
echo "#         ianaPen=IANA Pen&model=CPL Model&version=CPL Version" >> pki.sh
echo "#   OCF Security Claims fields" >> pki.sh
echo "#         secureBoot=off&hardwareStorage=on" >> pki.sh
echo "#   Manufacturer Usage Description" >> pki.sh
echo "#         mudUrl=https://www.domain.tld/resource" >> pki.sh
echo "#" >> pki.sh
echo "# creating pki zip file " >> pki.sh
echo "curl 'https://testcerts.kyrio.com/certificates' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Origin: https://testcerts.kyrio.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json, text/plain, */*' -H 'Referer: https://testcerts.kyrio.com/' -H 'DNT: 1' --data-binary '{\"device\":{\"manufacturer\":\"OCF\",\"name\":\"DeviceName1\"},\"subject\":\"pki_certs\",\"sizeCategory\":\"SMALL\",\"OCFVersionCompliance\":\"2.0.0\"}' --compressed > pki_certs.zip" >> pki.sh
echo "# creating header file from pki zip file " >> pki.sh
echo "python3 ./DeviceBuilder/src/pki2include.py -file pki_certs.zip" >> pki.sh
echo "# copy header file into the iotivity-lite tree " >> pki.sh
echo "cp ./pki_certs.zip.h ./iotivity-lite/include//pki_certs.h" >> pki.sh
#
# create the manufacturer_pki generation script, on the top level folder
#
echo "#!/bin/bash" > manufacturer_pki.sh
echo "# website: https://pki.openconnectivity.org/ocfTestCerts/" >> manufacturer_pki.sh
echo "# command to create the PKI zip file :" >> manufacturer_pki.sh
echo "# curl -d \"cn=Common Name&org=Member Organization&major=2&minor=0&build=1&baseline0=off&black0=on&blue0=on&purple0=on&devName=Device Name&devMfr=Device Manufacturer&ianaPen=IANA Pen&model=CPL Model&version=CPL Version&secureBoot=off&hardwareStorage=on&mudUrl=https://www.domain.tld/resource\" -X POST https://pki.openconnectivity.org/ocfTestCerts/generateTestCert.jsp > CommonName.zip"  >> manufacturer_pki.sh
echo "# Legend:"  >> manufacturer_pki.sh
echo "#   SubjectDN fields (required)"  >> manufacturer_pki.sh
echo "#           n=Common Name&org=Member Organization"  >> manufacturer_pki.sh
echo "#   OCF Compliance extension fields"  >> manufacturer_pki.sh
echo "#          major=2&minor=0&build=1&baseline0=off&black0=on&blue0=on&purple0=on&devName=Device Name&devMfr=Device Manufacturer "  >> manufacturer_pki.sh
echo "#   OCF CPL Attributes extension fields"  >> manufacturer_pki.sh
echo "#         ianaPen=IANA Pen&model=CPL Model&version=CPL Version"  >> manufacturer_pki.sh
echo "#   OCF Security Claims fields"  >> manufacturer_pki.sh
echo "#         secureBoot=off&hardwareStorage=on"  >> manufacturer_pki.sh
echo "#   Manufacturer Usage Description"  >> manufacturer_pki.sh
echo "#         mudUrl=https://www.domain.tld/resource"  >> manufacturer_pki.sh
echo "#"  >> manufacturer_pki.sh
echo "#if [ ! -f ./pki_certs.zip ]; then" >> manufacturer_pki.sh
echo "# creating pki zip file " >> manufacturer_pki.sh
echo "curl -d \"cn=pki_certs&org=OCF&major=2&minor=0&build=1&baseline0=on&black0=off&blue0=off&purple0=off&devName=DeviceName1&devMfr=OCF&ianaPen=IANA Pen&model=CPL Model&version=CPL Version&secureBoot=off&hardwareStorage=on&mudUrl=https://www.domain.tld/resource\" -X POST https://pki.openconnectivity.org/ocfTestCerts/generateTestCert.jsp > pki_certs.zip" >> manufacturer_pki.sh
echo "#fi" >> manufacturer_pki.sh
echo "# creating header file from pki zip file " >> manufacturer_pki.sh
echo "python3 ./DeviceBuilder/src/pki2include.py -file pki_certs.zip" >> manufacturer_pki.sh
echo "# copy header file into the iotivity-lite tree " >> manufacturer_pki.sh
echo "cp ./pki_certs.zip.h ./iotivity-lite/include//pki_certs.h " >> manufacturer_pki.sh
#
# create the build script, on the top level folder
#
echo "#!/bin/bash" > build.sh
echo "# script to build the target" >> build.sh
echo "# can accept arguments like TCP=1 CLOUD=1 CLIENT=1" >> build.sh
echo "cd iotivity-lite/port/linux/" >> build.sh
echo "#comment out one of the next lines to build another port" >> build.sh
for d in ./iotivity-lite/port/*/ ; do
    echo "#cd $d" >> build.sh
done
echo "#uncomment next line for having a clean build" >> build.sh
echo "#make clean" >> build.sh
echo "#uncomment next line for building the debug version" >> build.sh
echo "#make -f devbuildmake DYNAMIC=1 DEBUG=1 device_builder_server \$1 \$2 \$3" >> build.sh
echo "make -f devbuildmake DYNAMIC=1 device_builder_server \$1 \$2 \$3" >> build.sh
echo "cd ../../.." >> build.sh
#
# create the edit code script, on the top level folder
#
echo "#!/bin/bash" > edit_code.sh
echo "nano ./iotivity-lite/apps/device_builder_server.c" >> edit_code.sh
#
# create the edit input script, on the top level folder
#
echo "#!/bin/bash" > edit_input.sh
echo "nano ./example.json" >> edit_input.sh
#
# create the run script, on the top level folder
#
echo "#!/bin/bash"> run.sh
echo 'CURPWD=`pwd`'>> run.sh
echo "cd ./iotivity-lite/port/linux/" >> run.sh
for d in ./iotivity-lite/port/*/ ; do
    echo "#cd $d" >> run.sh
done
echo "pwd" >> run.sh
echo "ls" >> run.sh
echo "./device_builder_server" >> run.sh
echo 'cd $CURPWD' >> run.sh

#
# create the reset script, on the top level folder
#
echo "#!/bin/bash"> reset.sh
for d in ./iotivity-lite/port/*/ ; do
    echo "rm -rf ${d}device_builder_server_creds/*" >> reset.sh
done
echo "rm -rf ./iotivity-lite/port/windows/vs2015/x64/Debug/simpleserver_creds/*" >> reset.sh
echo "rm -rf ./iotivity-lite/port/windows/vs2015/x64/Release/simpleserver_creds/*" >> reset.sh
#echo "rm -rf ./iotivity-lite/port/linux/devicebuilderserver_creds/*" >> reset.sh

#
# go back to the current folder
#
cd $CURPWD

#
# add the build file
#
for d in ../iotivity-lite/port/*/ ; do
    cp ./environment-changes/devbuildmake ${d}devbuildmake
done

#
# make all scripts executable 
#
chmod a+x ../*.sh
