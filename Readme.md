# IOTivity-lite setup

## Introduction

This repo contains bash scripts to setup a build enviroment to use DeviceBuilder with IOTivity-lite.
The build enviroment is taylored to create OCF Server Devices.

The script setup the next repos (from github) in the folders:
- iotivity-lite (OCF 2.0 version): label: 2.1.1-RC1
- DeviceBuilder (latest version)
- IOTDataModels (latest version) resource definitions that are used as input for the code generation

## Table of Contents

- [IOTivity-lite setup](#iotivity-lite-setup)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Folder Structure After Installation](#folder-structure-after-installation)
  - [Development Setup](#development-setup)
  - [Referenced Information](#referenced-information)
  - [Development Flow](#development-flow)
  - [Initial Flow](#initial-flow)
  - [Repeat Flow](#repeat-flow)
    - [OCF clients](#ocf-clients)
  - [Scripts](#scripts)
    - [edit_input.sh](#editinputsh)
      - [Device Builder Input file](#device-builder-input-file)
      - [Nano](#nano)
    - [Generate Code](#generate-code)
      - [changing the device type of the OCF Server](#changing-the-device-type-of-the-ocf-server)
      - [changing the name of the OCF Server](#changing-the-name-of-the-ocf-server)
      - [WARNING](#warning)
    - [Edit Code](#edit-code)
    - [Build Code](#build-code)
    - [Run Code](#run-code)
    - [Reset Device](#reset-device)
    - [generate PKI certificates and header files](#generate-pki-certificates-and-header-files)
  - [Adding your own models](#adding-your-own-models)
  - [Windows Specific Instructions](#windows-specific-instructions)

## Installation

Installation of the enviroment can be done with a single curl command:

```curl  https://openconnectivity.github.io/IOTivity-Lite-setup/install.sh | bash```

The curl command sets up the full environment (for Linux and Windows).

If one wants to know the details of what the script does:
```curl  https://openconnectivity.github.io/IOTivity-Lite-setup/install.sh ``` or look 
[here](https://github.com/openconnectivity/IOTivity-Lite-setup/blob/master/install.sh)

Executing the installation command requires:

- internet access
- system that contains the BASH shell script environment.

Note that installing git clients on windows installs a BASH shell script environment

Note, Linux systems will be upgraded!


Use the following command to use the master (latest code) of Iotivity-Lite:

curl  https://openconnectivity.github.io/IOTivity-Lite-setup/install-master.sh | bash

## Folder Structure After Installation

Folder structure after everything is installed and code is generated:

    ~/iot-lite        
        |-- core             core resource definitions (in swagger) 
        |-- DeviceBuilder    The device builder tool chain
        |                    merging OAS2.0 files into 1 large OAS2.0 file for code generation
        |-- device_output    The output of device builder.
        |         |
        |         |-- code   The generated code.
        |               |    the files will be copied to folder iotivity/examples/OCFDeviceBuilder
        |               |- server.cpp                  <-- generated code, which will be copied
        |               |- server_security.dat         SVR data
        |               |- server_introspection.dat.h  introspection device data, encoded in header file
        |
        |-- iotivity-lite         IOTivity Lite source code
        |        | 
        |        |-- apps
        |        |      |- device_builder_server.c            <--- generated code
        |        |
        |        |-- include
        |        |      |- server_introspection.dat.h         <--- generated introspection data
        |        |
        |        |-- port/<portinglayer>
        |                     |- device_builder_server        <--- executable (after creation on linux)
        |                     |- devbuildmake                 <--- makefile with the target
        |                     |- Makefile                     <--- original make file from IOTivity_lite
        |                     |- device_builder_server_creds  <--- SVR storage 
        |                                                          when the folder is not there has the meaning: 
        |                                                          The device is ready for onboarding
        |                   
        |-- IoTDataModels    oneIOTa resource definitions (in OAS2.0 format)
        |-- IOTivity-Lite-setup   This github repo.
        |-- swagger2x        code generation tool, converting OAS2.0 into code
        |- gen.sh            generation command to convert the example.json in to code
        |- build.sh          building the generated code
        |- run.sh            run the generated code
        |- reset.sh          reset the device to ready for onboarding state.
        |- edit_code.sh      edits the iotivity-lite/apps/device_builder_server.cpp file with nano.
        |- edit_input.sh     edits the example.json file with nano.
        |- example.json      the input for device builder scripts.
            
            
     legenda:  folder
                  |-- folder
                  |-- folder/subfolder
                  |- file


The installDeviceBuilder script generates scripts in the top level folder (e.g. the folder above this repo).
The generated scripts are convienent scripts, e.g. they are short cuts for entering generation, build, excute and reset commands.
For more advanced usage, use the commands in the scrips itself, it allows for more flexibility in the development process.

## Development Setup

Typical development setup contains the following configuration:

              ----------------        
             | (dev system)   |             
             |  OCF server    |              
              ---------------- 
                     |
                wired|wifi
                     |
               --------------            ------------------             
              |              |   wifi   |                  |
    Internet--|    router    |--------- |  (test system)   |
              |              |          | OCF Client (OTGC)| 
               --------------            ------------------         

Where:

- Router = home router, with Wifi Access point to connect the Android device
- The IP network should be IPv6 capable and have CoAP multicast enabled.
- OCF Server = is the device that is being used to build the OCF server
  - Linux PC or Raspberry Pi
- OCF Client = device used to run the OCF Client (OTGC)
 	- Linux PC (build your own on target PC)
 	- Raspberry Pi (build your own on a PI)
	- Android Phone (OTGC as pre-build apk available)

see for options on [OTGC](https://openconnectivityfoundation.github.io/development-support/otgc)
Note that a Windows (10) PC can be used to run OCFDeviceSpy as OCF Client.
[Device Spy](https://openconnectivityfoundation.github.io/development-support/DeviceSpy)
is a lower level OCF client where the user needs to interact with the device on JSON level.

## Referenced Information

| repo  |  description |
| ----- | ----- |
| [DeviceBuilder](https://github.com/openconnectivityfoundation/DeviceBuilder) |  tool chain  |
| [swagger2x](https://github.com/openconnectivityfoundation/swagger2x) |  templated code generation   |
| [IoTivity-lite](https://github.com/iotivity/iotivity-lite)     |  C code (latest)   |
| [IOTdataModels](https://github.com/openconnectivityfoundation/IoTDataModels) |  [oneIOTa](https://oneiota.org)  |
| [core](https://github.com/openconnectivityfoundation/core)        |  OCF core data models   |
| [OCF clients](https://github.com/openconnectivityfoundation/development-support)          |  OCF development clients (prebuild) |

## Development Flow

The development flow is based on bash scripts, hence the flow is generalized for Linux based systems.
The development flow is depicted the figure below:

                   start
                     |       
                     v
               --------------                  
              |              |     
              | edit_input.sh|             --- edit the input file for the code generation
              |              |                 default file contains the binary switch resource
               -------------- 
                     |
                     |       
                     v
               --------------
              |              |
              |    gen.sh    |             ---  generates the code & introspection file
              |              |             --- script contains the device type, 
               --------------                  change the argument to change the device type.
                     |
                     | initial code        --- in iotivity-lite tree, to build
                     v                     --- introspection header files
               --------------                  
              |              |     
              | edit_code.sh |<--------    --- edit the generated code
              |              |         |
               --------------          |
                     |                 |
                     | edited code     |
                     v                 |
               --------------          |
              |              |  build  |
              |   build.sh   |---->----|   --- build the executable
              |              |  failed |
               --------------          |
                     |                 |
                     | ok              |
                     v                 |
               --------------          |
    run       |              | modify  |
    --------->|    run.sh    |---->----      --- onboarding will change the security folder 
    clients   |              | behaviour         in the executable folder
    against    --------------                    to refresh/reset the security status execute reset.sh
    application      |
                     v
                  finished
                 
        Note: if gen.sh is run again, the generated code is overwritten.
        e.g. before running that tool again, safe the file in the iotivivty tree to another name 
        if one wants to keep that code as reference

## Initial Flow

These steps needs to be executed in the __&lt;&gt;/iot-lite__ folder, 
e.g. the folder that gets created by running the curl installation command.
The goal is to run an OCF server by creating code, building and running the OCF server application.

1 [gen.sh](#generate-code)
 Script to generate the code that represents the device.
    The input is the file used to generate the code is __example.json__.
2. [build.sh](#build-code)
Script to build the generated code.
The __device_builder_server.c__ code  is being build is located at __&lt;&gt;/iot-lite/iotivity-lite/apps__ folder.
3. [run.sh](#run-code)
Script to run (launch/start) the compiled (generated) code.
The script executes __device_builder_server__ application in the __&lt;&gt;/iot-lite/iotivity-lite/port/linux__ folder.

## Repeat Flow

The repeat flow is modifying the generated code (without code generation):

1. [edit_code.sh](#edit-code)
Script to edit the generated code with Nano.
2. [build.sh](#build-code)
Script to build the generated code.
3. [run.sh](#run-code)
Script to run (launch/start) the compiled (generated) code.

If the device needs to be in ready for onboarding (for example after a crash), 
then run the script [reset.sh](#reset-device)

### OCF clients

Information and Installers about the OCF clients for development support can be found [here](https://github.com/openconnectivityfoundation/development-support)

## Scripts

### edit_input.sh

This scripts edits the device builder input file with [Nano](#Nano) editor.
The input file being edited is located at the top of the tree.

Typical changes on the input file for code generation can be:

- adding/changing resources.
- removal of **optional** properties on the resource.
- removal of the UPDATE method (e.g. POST).
Things to check:
- do not remove mandatory features from a resource
- make sure that if an UPDATE method is removed, also change the supported inteface (if)

Information on available which device types should implement which resources can be found [here](https://openconnectivityfoundation.github.io/devicemodels/docs/index.html).
Information on the individual resources in OAS2.0 format can be found in [oneIOTa](https://oneiota.org).

Recommendation:

**Make sure that before starting to change the generated code, all resources & properties are supported by the generated code.**

#### Device Builder Input file

More information on the Device Builder input file can be found [here](https://github.com/openconnectivityfoundation/DeviceBuilder/tree/master/DeviceBuilderInputFormat-file-examples/readme.md)
This link contains the syntax and some examples of input files.

#### Nano

Nano is a small editor that can be used to edit files in windowless system.
Nano is supplied on various linux systems like ubuntu and raspberry pi.
Please make sure when generating a new version, that a changed file is saved under a different name.
Nano beginners guide is available [here](https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/).

### Generate Code

script: **gen.sh**

This script runs the DeviceBuilder application with the predefined arguments:

- iot-lite/example.json as input file.
- light device as device type.

#### changing the device type of the OCF Server

The device type can be change from oic.d.light (default) to something different. 
The following mechanisms are available to change the device type:

- change the server code from oic.d.light to the specific value.
  - search for oic.d.light in the server code, and change the value.
  - no need to re-generate the server code.
  - can be done when one is already changing the server code.
- change the gen.sh file e.g. replace oic.d.light to something
  - to see the changes the code needs to be re-generated by running gen.sh
  - can be done when no code has been changed yet.

#### changing the name of the OCF Server

The name can be change to something different. 
This can be done by giving an input parameter to gen.sh.
for example gen.sh blahblah will turn the name of the server into "blahblah".
Default the name of the device is "server_lite_&lt;PID&gt;", the PID is the current process number of the script.
Hence the default name scheme creates unique device names.

#### WARNING

Running this script generates the device_output folder AND copies the result to the correct executable folder in the iotivity-lite tree structure.

more info of the DeviceBuilder script can be found [here](https://github.com/openconnectivityfoundation/DeviceBuilder).

**Note that running gen.sh will overwrite the made code changes!!**

### Edit Code

script: **edit_code.sh**

This scripts edits the generated C code __device_builder_server.c__ with [Nano](#nano).
The script loads the Nano editor with the generated code in the IOTivity tree.
The saved file can be compiled without copy pasting.

**Note that running gen.sh will overwrite the made changes!!**

Typical changes to be applied on the code:

- making sure that the code passes OCF Compliance Test Tool (CTT).
  - Some resources may have mandatory behavior not captured in OAS2.0 format.
    This behaviour has be added in the resource handlers functions of the resource.
- attaching the code to hardware.
  - See the TODO comments in the generated code.
    The TODOs indicates where the code could be inserted.
    There are different insertions, depending on whether the resource is a sensor or an actuator.
    - See also the raspberry hat examples
      These examples have code to talk to the sensors and actuators of raspberry hat.  

More info about the structure of the generated code can be found [here](https://openconnectivityfoundation.github.io/swagger2x/src/templates/IOTivity-lite).

### Build Code

script: **build.sh**

This script builds the app device_builder_server.c by means of make.
e.g. run in the iotivity-lite/port/linux folder the ```make -f devbuildmake device_builder_server``` command.

To build another port (e.g. OS):

- uncomment out the listed port in the script, and comment out the default linux.

To have clean build edit the build.sh file and comment out the line: __make clean__.

To build a server that is cloud capable, add on the command line the compile directive: CLOUD=1
e.g.: __sh build.sh CLOUD=1__

### Run Code

script: **run.sh**

This script executes the compiled executable in the folder where the executable resides in.

e.g. it executes the __device_builder_server__ executable (e.g. the server application) in folder:

./iotivity-lite/port/linux/

note that the executable needs to be started in folder where it recides to avoid issues with reading the security data.


### Reset Device

script: **reset.sh**

This script deletes the SVR settings in the security folder:

./iotivity/port/linux/device_builder_server_creds

The device will go to the ready for onboarding state.

### generate PKI certificates and header files

script: **pki.sh**

This script creates PKI based certificates and converts them into an header file so that they are used in the code.

see for more info on [security options](/IOTivity-Lite-setup/security.md)

## Adding your own models

Instructions to add your own models available are [here](/IOTivity-Lite-setup//adding_my_own_models.md).

## Windows Specific Instructions

Windows specific instructions are available are [here](/IOTivity-Lite-setup/windows.md).
