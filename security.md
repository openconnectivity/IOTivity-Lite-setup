# IoTivity-lite Owner Transfer Methods

## Table of Contents

- [IoTivity-lite Owner Transfer Methods](#iotivity-lite-owner-transfer-methods)
  - [Table of Contents](#table-of-contents)
  - [Onboarding Introduction](#onboarding-introduction)
  - [Just works](#just-works)
    - [Just works compile flags](#just-works-compile-flags)
  - [Random Pin](#random-pin)
    - [random pin compile flags](#random-pin-compile-flags)
  - [Certificate based](#certificate-based)
    - [pki compile flags](#pki-compile-flags)

## Onboarding Introduction

OCF has 3 Owner Transfer Methods:

- [Just works](#just-works)
- [Random Pin](#random-pin)
- [Certificate based](#certificate-based)
All Methods are supported in IoTivity_lite.

See for specific details the [security specification](https://openconnectivity.org/specs/OCF_Security_Specification.pdf) and the [onboarding tool specification](https://openconnectivity.org/specs/OCF_Onboarding_Tool_Specification_v2.1.2.pdf)

## Just works

### Just works compile flags

compile flags to enable just works onboarding.

- OC_SECURE

## Random Pin

The OCF Device needs to be in close proximity, since the end user needs to read the generated PIN value from the device and put the value in the onboarding tool

### random pin compile flags

compile flags to enable Random Pin onboarding

- OC_SECURE

## Certificate based

### pki compile flags

compile flags to enable using certificate based (PKI) onboarding

- OC_SECURE
- OC_PKI