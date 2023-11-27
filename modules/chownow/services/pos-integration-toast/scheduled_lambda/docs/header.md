# Toast POS Service Scheduled Lambda Module

### General

* Description: A sub-module to POS toast integration service
* Created By: Rafal Fiedosiuk and Kacper Stasica
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

The goal is to implement a reusable module with EventBridge + Lambda combination, which integrates with different components of POS Integration toast service such as partner & menu sync handler. This module is designed with a flow where Lambda will be invoked by an EventBridge rule (schedule expression).

