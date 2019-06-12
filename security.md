# IOTivity-lite Owner Transfer Methods

# Introduction
OCF has 3 Owner Transfer Methods:
- just works
- random pin
- pki
All Methods are supported in IOTivity_lite.

see for specific details:

https://openconnectivity.org/specs/OCF_Security_Specification.pdf

# Just works


## compile flags 
- OC_SECURE

# Random Pin
The OCF Device needs to be in close proximity, since the end user needs to read the generated PIN value from the device and put the value in the onboarding tool

## compile flags 
- OC_SECURE


# Certificate based

## compile flags to enable using certificate based onboarding
- OC_SECURE 
- OC_PKI