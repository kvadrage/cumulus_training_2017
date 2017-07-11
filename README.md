# cumulus_training_2017

## Vagrant topology for Cumulus training

**NOTE**: in order to use this Vagrantfile you will need:
* Vagrant(v1.8.6+) installed: http://www.vagrantup.com/downloads
* Virtualbox installed: https://www.virtualbox.org/wiki/Downloads
* Internet connection

## Topology
See **demo_topology.dot**.

## Usage
* Install Virtualbox, Vagrant and Git
* Clone this repository: `git clone https://github.com/kvadrage/cumulus_training_2017.git`
* Enter **cumulus_training_2017** directory
* Run `vagrant up` and wait for a few minutes until Vagrant topology is being provisioned
* By default all nodes are managed from **oob-mgmt-server** VM:
  * Run `vagrant ssh oob-mgmt-server`
  * Log in as **cumulus** user: `sudo su - cumulus`
  * SSH to any node in the topology: `ssh leaf01`
* If you are low on memory and don't want to set up additional VMs:
  * Create only specific VMs, that you really need: `vagrant up leaf01 leaf02 spine`
  * SSH directly to them: `vagrant ssh leaf01`
  * This will require a little bit more configuration on each node to set everything up

## HW requirements
* Multi-core CPU
* At least 4GB RAM (8GB will be much better)
* 20-25GB free disk space

## Customization
If you want to customize Vagrant topology, use Cumulus [topology_converter](https://github.com/CumulusNetworks/topology_converter)
and `demo_topology.dot` file as a reference.
