# CNOS

#### Table of Contents


1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with ntp](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)


## Module description

This module uses REST to manage various Network management aspects of Lenovo CNOS Switches and acts as a foundation for building higher level abstractions within Puppet. The cnos module provides a set of types and providers for managing Lenovo CNOS switches. The module provides resources for the VLAN provisioning, Vlag provisioning, Arp, Telemetry, LAG, LACP, IP-Interface Mapping, VLAN-Port Mapping etc . The module allows you to manage CNOS Switches deployed in a network, in order to manage much of your CNOS configuration through Puppet.


## Setup

### Beginning with cnos in puppet

Before you can use the CNOS module, you must create a proxy system able to run puppet device. Your Puppet agent will serve as the "proxy system" for the puppet device subcommand.

Create a device.conf file in the Puppet conf directory (either /etc/puppet or /etc/puppetlabs/puppet) on the Puppet agent. Within your device.conf, you must have:

~~~
[cnos.switch.labs.lenovo.com]
type cnos
url https://<USERNAME>:<PASSWORD>@<IP ADDRESS OF CNOS Switch>/
~~~

In the above example, `<USERNAME>` and `<PASSWORD>` refer to Puppet's login for the device. And cnos.switch.labs.lenovo.com is the domain name of the switch 

Additionally, you must install the lenovo-rbapi gem into the Puppet Ruby environment on the proxy host (Puppet agent) by declaring the cnos-rbapi class on that host. If you do not install the lenovo-rbapi gem, version 0.0.5, the module will not work.

## Usage


### Install and set up 

The following pre-existing infrastructure is required for the use of cnos module:

1. A server running as a Puppet master.
2. A Puppet agent running as a proxy or controller to the CNOS device.
3. A CNOS device that has been registered with the Puppet master via the proxy or controller.
5. Download CNOS Module from Puppet forge and install it into your Pupet master

### Steps

1.  Classify the CNOS device with the required resource types.
2.  Apply classification to the device from the proxy or controller by running `puppet device -v --user=root`.

See below for the detailed steps.

#### Step One: Classifying your servers

   In case, you have installed the puppet master in server with domain name, say, server.labs.lenovo.com, then you will be able to access the UI of puppet master with the following URL.
https://server.labs.lenovo.com/
This will prompt you for a username and password which u have set up during the master installation. On successful login you will be lead to Overview page. On the right handside you will be able to find menu item for Classification under Configure section. Click on that. In case your CNOS installation has gone successfully you will be able to find your CNOS Module under "All Nodes"

Click on the CNOS Nodes and your will be reach a page where the default tab is Rules. In the page u should be able to find the the nodes pinned to this group. You will be able to find the node u added to the puppet device in this section, if not u have to run the puppet device command to generate certificate and add your device to this classification. 

Click on the Configuration tab and click on Add new class text area to list all the classes available for your to execute onto a switch. If you cannot find the classes starting with cnos:: then your manifests are not listing your which means your installation of cnos module is not successful.

#### Step Two: Run puppet device

Run the following command to have the device proxy node generate a certificate and apply your classifications to the CNOS device.

~~~
$ puppet device -v --user=root
~~~

If you do not run this command, clients cannot issue REST Commands to the CNOS Switches.

At this point, your set up should be up and fielding requests.

(Note: Due to [a bug](https://tickets.puppetlabs.com/browse/PUP-1391), passing `--user=root` is required, even though the command is already run as root.)



## Reference

### Classes

#### Public classes

* cnos: Main class, includes all other classes.

#### Private classes

ToDO

#### Types

ToDO

### Limitations

ToDO

### Development

ToDO

### Support


ToDO
