# Adding my own models

The enviroment has been set up with all OCF models taken from github
[IOTdataModels](https://github.com/openconnectivityfoundation/IoTDataModels)

The scripts are looking resource types in the local folder of the cloned repo.
The folder of the cloned repo is located at:
    
    ~/iot-lite        
        |-- 
        |                   
        |-- IoTDataModels    <-- resource definitions (in OAS2.0 format)


DeviceBuilder is not looking at filename, but the tool is creating an look up map between the
rt value of the model and the file name.
The used rt value should not clash with the existing rt values used by OCF.
Perferable the rt value should be registered with IANA.

existing resources can be easily searched via 
[this tool](https://openconnectivityfoundation.github.io/devicemodels/docs/resource.html)
this tool also contains information on device types and the expected resources to be implemented in the device.

Steps:
- add your own data models in the IoTDataModels folder in OAS2.0 format 
- change the input file so that it uses the "rt" value in of the model.
- run gen.sh
- compile on the used system

The algorithm used to search for the resource type is per OAS2.0 file. 
The rt value will be retrieved from the following locations in the file:
- x-example of the GET method
- x-example of the POST method
- schema of the GET method
  the schema should be a reference ($ref) to a defintion of the schema.


