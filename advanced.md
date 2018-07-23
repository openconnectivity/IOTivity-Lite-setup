# Advanced usage
Scripts that are intended for usage after initial setup.

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
- this step creates in the folder iotivity-constrained (to be renamed) /apps the file device_builder_server.c 
    - copy this file over the existing simpleserver_windows.code (not nice, but it works)
- start up visual studio project "SimpleServer" in folder :
    - \iotivity-constrained\port\windows\vs2015
    - IoTivity-Constrained project is the library, e.g. can't be runned.
- when using visual studio 2017 instead of 2015: to a retarget on project.

Resetting the device to ready for onboarding:

delete the folder:
- iotivity-constrained\port\windows\vs2015\Debug\x64\simpleserver_creds