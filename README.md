#PCH LAMP Stack on CentOS 6.4 Built with Vagrant/Puppet#

The purpose is to set up a dev environment that matches as close to production specs as possible/reasonable. The relevant production specs include:
    - CentOS 6.4, Kernel 2.6.32-358.23.2.el6.x86_64
    - PHP 5.3
    - Apache 2.2.15
    - mysql 5.5

Do note that the first run might take a while. Depending on your speed, 10 minutes to download the base VM (CentOS 6.4) and 5 minutes to startup and provision the VM. But subsequent startup should be quite fast.

You can spin up new boxes very easily. Just put your PHP scripts in the `project` folder and add a new vhost. If you are lazy, just throw your PHP files into the `project/webroot` folder.

## Pre-Requisite Software ##

* VirtualBox (>= 4.3.2) ([https://www.virtualbox.org/](https://www.virtualbox.org/))
* VirtualBox Extension Pack ([https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads))
* Vagrant (>= 1.3.5) ([http://vagrantup.com/](http://vagrantup.com/))
* Librarian-Puppet ([https://github.com/rodjek/librarian-puppet](https://github.com/rodjek/librarian-puppet))

##Installation Instructions##

0. Your project(s) source code is expected to live under a `../projects` directory relative to your vm directory

1. Install `Puppet` & `Librarian-Puppet`

	```bash
$ sudo gem install puppet
$ sudo gem install librarian-puppet
```

2. Clone this Git Repository, (the following assumes your `projects` dir lives at ~/projects)

	```bash
$ cd ~/
$ git clone git@github.com:marrone/vagrant-lamp-centos64.git
$ cd vagrant-lamp-centos64
```

3. Install Puppetfile dependencies

	```bash
$ cd puppet
$ librarian-puppet install
```
4. Start Vagrant

	```bash
$ cd ..
$ vagrant up --provision
```

5.  Once startup in complete, point your browser to `http://localhost:8080` to make sure Apache is running.


## Usage ##

* The vm is assigned a static IP of 192.168.33.10 and defaults to listing your projects directory root

* Put your files in `~/projects` to make it appear in the Apache document root. The `~/projects` folder is mapped to `/vagrant_projects` in the VM.

* Your vm install dir is mapped to `/vagrant` in the VM. You can easily share files between host/guest by placing files in this directory or in your `~/projects` directory

* The MySQL username is `root` and the root password is `pch`.

* To login into the VM type

	```bash
$ vagrant ssh
```

* To stop the VM:

	```bash
$ vagrant suspend
```

* To halt the VM:

	```bash
$ vagrant halt
```

* To destroy the VM:

	```bash
$ vagrant destroy
```

* To run Puppet again:

	```bash
$ vagrant provision
```

* Whenever you make any changes to `Vagrantfile`, run:

	```bash
$ vagrant reload --provision
```

## Customization ##

All the configuration are in `Vagrantfile` and in the `puppet/manifests/hieradata/common.yaml`. Feel free to explore and tweak the settings to your liking.

You can add a new new vhosts in `puppet/modules/pch/manifests/init.pp`

## Disclaimer ##

This configuration was successfully tested on Mac OSX Mavericks.
