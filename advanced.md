# Advanced usage
Scripts that are intended for usage after initial setup.

# manual steps for setting up the build environment


This repo contains bash scripts to setup a build enviroment to use DeviceBuilder with IOTivity-lite.
The script setup the next repos (from git) in the folders:
- iotivity-lite (latest version)
- DeviceBuilder (latest version)

Typical folder layout to start from (e.g. create the iot-lite folder in the home folder)
     
     
     ~/iot-lite
     
clone in this folder:

```git clone https://github.com/openconnectivity/IOTivity-Lite-setup.git```
     
This command will give the next folder structure :
     
     ~/iot-lite
        |-IOTivity-Lite-setup 
    
From the IOTivity-Lite-setup folder run the scripts (in order):
- install_IOTivity-lite.sh
- install_DeviceBuilder.sh


e.g. exectute in the <>/iot-lite/IOTivity-Lite-setup folder: sh install_<>.sh


# update_repos.sh
The update_repos.sh script updates the: 
- tooling repos
- datamodels repos

The script does NOT update the code repos:
- iotivity-lite
The code repo iotivity is pulled at start up with a specific version.
To get a fresh copy, delete the folder and rerun the install_IOTivity.sh script.


# compiling on windows.

using vs2017:

- do the generation of the code as is with sh gen.sh.
- this step creates in the folder iotivity-lite (to be renamed) /apps the file device_builder_server.c 
    - copy this file over the existing simpleserver_windows.code (not nice, but it works)
- start up visual studio project "SimpleServer" in folder :
    - \iotivity-lite\port\windows\vs2015
    - IoTivity-Constrained project is the library, e.g. can't be runned.
- when using visual studio 2017 instead of 2015: to a retarget on project.

Resetting the device to ready for onboarding:

delete the folder:
- iotivity-lite\port\windows\vs2015\Debug\x64\simpleserver_creds