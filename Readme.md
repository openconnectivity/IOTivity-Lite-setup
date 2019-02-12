# IOTivity-lite setup

This repo contains bash scripts to setup a build enviroment to use DeviceBuilder with IOTivity-lite.
The build enviroment is taylored to create OCF Server Devices.

The script setup the next repos (from github) in the folders:
- iotivity-lite (OCF 1.3 version) note that the created folder is called iotivity-constrained.
- DeviceBuilder (latest version)
- IOTDataModels (latest version) resource definitions that are used as input for the code generation

## Installation
Installation of the enviroment can be done with a single curl command:

```curl  https://openconnectivity.github.io/IOTivity-Lite-setup/install.sh | bash```

The curl command sets up the full environment (for Linux and Windows).

If one wants to know the details of what the script does:
```curl  https://openconnectivity.github.io/IOTivity-Lite-setup/install.sh ``` or look at
https://github.com/openconnectivity/IOTivity-setup/blob/master/install.sh

Executing the installation command requires:
- internet access
- system that contains the BASH shell script environment.

Note that installing git clients on windows installs a BASH shell script environment

## Folder Structure After Installation
Folder structure after everything is installed and code is generated:
    
    ~/iot-lite        
        |-- core             core resource definitions (in swagger) 
        |-- DeviceBuilder    The device builder tool chain
        |-- device_output    The output of device builder.
        |         |
        |         |-- code   The generated code.
        |               |    the files will be copied to folder iotivity/examples/OCFDeviceBuilder
        |               |- server.cpp
        |               |- server_security.dat         SVR data
        |               |- server_introspection.dat.h  introspection device data, encoded in header file
        |
        |-- iotivity-constrained         IOTivity Lite source code
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
        |-- IOTDataModels    oneIOTa resource definitions (in swagger format)
        |-- IOTivity-Lite-setup   This github repo.
        |-- swagger2x        swagger2x code generation
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
        
        
The installDeviceBuilder script generates scripts in the top level folder (e.g. above this repo).
These scripts are convienent scripts, e.g. they are short cuts for entering generation, build, excute and reset commands.

## Development Setup
Typical development setup contains the following configuration:
     
              ----------------                  
             | PC/RaspberryPi |     
             | (dev system)   |             
             |  OCF server    |              
              ---------------- 
                     |
                wired|wifi
                     |
               --------------            ------------------             
              |              |   wifi   |  Android Device  |
    Internet--|    router    |--------- |  (test system)   |
              |              |          | OCF Client (OTGC)| 
               --------------            ------------------         
               
Where:
  - Router = home router, with Wifi Access point to connect the Android device
  - (Linux)PC/RaspberryPi = is the device that is being used to build the OCF server
  - Android Device = device used to run the OCF Client (OTGC): 
                
    see https://github.com/openconnectivityfoundation/development-support/otgc
           
Note that a windows (10) PC instead of an Android device can be used to run OCFDeviceSpy as OCF Client.
see https://github.com/openconnectivityfoundation/development-support/DeviceSpy


## Referenced Information:

| repo  |  description | location |
| ----- | ----- | -------|
| DeviceBuilder |  tool chain  | https://github.com/openconnectivityfoundation/DeviceBuilder |
| swagger2x |  code generation  | https://github.com/openconnectivityfoundation/swagger2x |
| IOTivity-constrained     |  C code (latest)     | https://iotivity.org/ https://github.com/iotivity/iotivity-constrained |
| IOTdataModels  |  oneIOTa data models https://oneiota.org  |https://github.com/openconnectivityfoundation/IoTDataModels |
| core          |  OCF core data models  | https://github.com/openconnectivityfoundation/core |
| OCF clients          |  OCF development clients  | https://github.com/openconnectivityfoundation/development-support |
    
    
# Development Flow
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


# Initial Flow

The Initial flow is doing a generation (with the supplied example):
1. [gen.sh](#generate-code)
	
	script to generate the code that represents the device.
2. [build.sh](#build-code)
	
	script to build the generated code.
3. [run.sh](#run-code)
	
	script to run (launch/start) the compiled (generated) code.

# Repeat Flow
The repeat flow is doing (without code generation):

1. [edit_code.sh](#edit-code)
	
	script to edit the generated code with Nano.
2. [build.sh](#build-code)

	script to build the generated code.
3. [run.sh](#run-code)
	
	script to run (launch/start) the compiled (generated) code.
	
	
if the device needs to be in ready for onboarding, then run the script [reset.sh](#reset-device)


### OCF clients    
    
Information and Installers about the OCF clients for development support can be found at:

https://github.com/openconnectivityfoundation/development-support

# scripts

## edit_input.sh
This scripts edits the device builder input file with Nano.
Nano is a small editor that can be used to edit files in windowless system.

### Nano
Nano is supplied on various linux systems like ubuntu and pi.
The file being edited is the file in iotivity tree.
so please make sure when generating a new version, that a changed file is saved under a different name.

nano beginners guide:

https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/

### input file
Device Builder input file information can be found at:
https://github.com/openconnectivityfoundation/DeviceBuilder/tree/master/DeviceBuilderInputFormat-file-examples

    
## generate code

script: **gen.sh**

This script runs the DeviceBuilder with the arguments:
- iot-lite/example.json as input file
- light device as device type

when the device type needs to change from oic.d.light to something else
the next mechanisms are available to change the device type:
- change the server code from oic.d.light to the specific value
	- search for oic.d.light in the server code, and change the value.
	- no need to re-generate the server code
	- can be done when one is already changing the server code.
- change the gen.sh file e.g. replace oic.d.light to something
	- to see the changes the code needs to be re-generated by running gen.sh
	- can be done when no code has been changed yet.


Running this script generates the device_output folder AND copies the result to the correct executable folder in the iotivity-lite tree structure.

more info of the DeviceBuilder script can be found at:
https://github.com/openconnectivityfoundation/DeviceBuilder

**Note that running gen.sh will overwrite the made code changes!!**

## edit code

script: **edit_code.sh**

This scripts edits the generated C code with [Nano](#nano).

**Note that running gen.sh will overwrite the made changes!!**

## build code

script: **build.sh**

This script builds the app device_builder_server.c by means of make.
e.g. run in the iotivity-lite/port/linux folder the ```make -f devbuildmake device_builder_server``` command

To build another port (e.g. OS):
- uncomment out the listed port in the script, and comment out the default linux.

## run code

script: **run.sh**

This script executes the executable in the folder where the executable resides in.

e.g. it executes the device_builder_server executable (e.g. the server application) in folder:

./iotivity-lite/port/linux/

note that the executable needs to be started in folder where it recides to avoid issues with reading the security data.


## reset device

script: **reset.sh**

This script deletes the SVR settings in the security folder:

./iotivity/port/linux/device_builder_server_creds

The device will go to the ready for onboarding state.


#  windows specific instructions
instructions see :
https://github.com/openconnectivity/IOTivity-Lite-setup/blob/master/windows.md
