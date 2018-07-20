# IOTivity-lite setup

This repo contains bash scripts to setup a build enviroment to use DeviceBuilder with IOTivity-lite.
The scripts setup the next repos (from git) in the folders:
- iotivity-lite (latest version)
- DeviceBuilder (latest version)

All repos are being set up 1 level above the folder of IOTivity-setup folder.

Typical folder layout to start from (e.g. create the iot folder in the home folder)
     
     
     ~/iot-lite
     
clone in this folder:

```git clone https://github.com/openconnectivity/IOTivity-setup.git```
     
This command will give the next folder structure :
     
     ~/iot-lite
        |-IOTivity-Lite-setup 
    
From the IOTivity-Lite-setup folder run the scripts (in order):
- install_IOTivity-lite.sh
- install_DeviceBuilder.sh


e.g. exectute in the ~/IOT/IOTivity-setup folder: sh install_<>.sh

Note running:

```curl  https://openconnectivity.github.io/IOTivity-Lite-setup/install.sh | bash```

will do the same steps as described above, including the creation of the IOT folder.
If one wants to see the script:
```curl  https://openconnectivity.github.io/IOTivity-setup/install.sh ``` or look at
https://github.com/openconnectivity/IOTivity-setup/blob/master/install.sh


Folder structure after everything is installed:
    
    ~/iot        
        |-- core             core resource definitions (in swagger) 
        |-- DeviceBuilder    The device builder tool chain
        |-- device_output    The output of device builder.
        |         |
        |         |-- code   The generated code.
        |               |    the files will be copied to folder iotivity/examples/OCFDeviceBuilder
        |               |- server.cpp
        |               |- server_security.dat       SVR data
        |               |- server_introspection.dat  introspection device data
        |
        |-- iotivity-lite         IOTivity source code
        |        | 
        |        |-- examples
        |        |        |
        .
        |                   
        |-- IOTDataModels    oneIOTa resource definitions (in swagger)
        |-- IOTivity-Lite-setup   This repo.
        |-- swagger2x        swagger2x code generation
        |- gen.sh            generation command to convert the example.json in to code
        |- build.sh          building the generated code
        |- run.sh            run the generated code
        |- reset.sh          reset the device to ready for onboarding state.
        |- edit_code.sh      edits the iotivity/examples/OCFDeviceBuilder/server.cpp file with nano.
        |- example.json      the input for device builder.
            
            
     legenda:  folder
                  |-- folder
                  |-- folder/subfolder
                  |- file

        
        
The installDeviceBuilder script generates scripts in the folder above this repo.
These scripts are convienent scripts, e.g. they are short cuts for entering generation, build, excute and reset commands.


referenced information:

| repo  |  description | location |
| ----- | ----- | -------|
| DeviceBuilder |  tool chain  | https://github.com/openconnectivityfoundation/DeviceBuilder |
| swagger2x |  code generation  | https://github.com/openconnectivityfoundation/swagger2x |
| IOTivity_lite     |  C code (latest)     | https://iotivity.org/ https://github.com/iotivity/iotivity-constrained |
| IOTdataModels  |  oneIOTa data models https://oneiota.org  |https://github.com/OpenInterConnect/IoTDataModels |
| core          |  OCF core data models  | https://github.com/openconnectivityfoundation/core |

    