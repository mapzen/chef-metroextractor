Metroextractor Chef Cookbook
===================

Chef cookbook to automate the building of metro extracts.
Heavily influenced/borrowed from Mike Migurski's [Extractotron](https://github.com/migurski/Extractotron/)

!!! NOTE !!! Currently still in development... things can (and will) change, but master is functional.

What does it do?
----------------
Downloads the latest planet in pbf format, and runs through it via osmosis to produce a number of metro
extracts in both pbf and bz2 format. If there's demand/interest, we may add back shp files, but for now
it's just extracts.

What hardware do I need?
------------------------
On AWS, using a c3.2xlarge, it takes about 2 days to process all the extracts should you want to produce
your own.

If you'd rather not go that route, you're in luck. We'll be producing extracts weekly, and you can find
then here: [Mapzen Metro Extracts](http://metro-extracts.mapzen.com)

Current Build Status
--------------------
[![Build Status](https://secure.travis-ci.org/mapzen/chef-metroextractor.png)](http://travis-ci.org/mapzen/chef-metroextractor)

Usage
-----
    include_recipe 'metroextractor'

Supported Platforms
-------------------
Tested on Ubuntu12.04LTS. You can probably get away with distributions similar to those, but as yet
they have not been tested.

Requirements
------------
* Chef >= 11.4

Attributes
----------
### metroextractor.setup

#### basedir
Base working directory
* type: string
* default: /mnt

#### scriptsdir
Where to install scripts
* type: string
* default: /opt/metroextractor-scripts

### metroextractor.user

#### id
User to run everything as
* type: string
* default: postgres

#### shell
User shell
* type: string
* default: /bin/bash

#### manage_home
Private
* type: string
* default: false

#### create_group
Create the user group
* type: boolean
* default: true

#### ssh_keygen
Generate ssh keys for the user
* type: boolean
* default: false

### metroextractor.planet

#### url
Where to download the planet
Currently required to be pbf (not validated)
* type: string
* default: http://ftp.heanet.ie/mirrors/openstreetmap.org/pbf/planet-latest.osm.pbf

#### file
Derive the name of the planet download from the url
Currently required to be pbf (not validated)
* type: string
* default: ```planeturl.split('/').last```

### metroextractor.extracts

#### osmosis_timeout
Set the timeout for processing of pbf/bz extracts
* type: int
* default: 172,800 (2 days)

#### osmosis_force
By default, if the omosis extracts successfully build, we write a lock file
to prevent the process from running again and overwritting data. You can 
either remove the lockfile to bypass this, or force a run by setting this
value to true.
* default: nil

#### osmosis_lock
Location of osmosis lockfile
* type: string
* default: basedir/.osmosis.lock

#### osmosis_jvmopts
JVM options to pass to osmosis. Xmx is calculated automatically and 
set to total available RAM: ```node[:memory][:total].to_i / 1024```
* type: string
* default: '-server -Xmx#{mem}''

Upstream cookbook overrides

### osmosis

#### symlink
Create a symlink into /usr/bin
* default: true

#### install_type
Install from source
* default: tgz

Dependencies
-----------
apt, osm2pgsql, osmosis postgresql

Vagrant Environment
===================

Installation
------------
    vagrant plugin install vagrant-berkshelf 
    bundle install
    berks install
    vagrant up
    vagrant ssh

#### Note
* running a planet download and then processing extracts on your local machine might be hit or miss

#### I don't like Vagrant
* well then sir, provision an Ubuntu12.04 LTS system with the provider of your choice, and then bootstrap with chef-solo:
    `knife solo bootstrap root@${host} -r 'recipe[metroextractor]'`
* and re-cook with the following:
    `knife solo cook root@${host} -r 'recipe[metroextractor]'`
* alternatively, you can add the metroextractor cookbook to your chef server and wrap it as you see fit

Contributing
------------
Fork, create a feature branch, write specs, send a pull! Weeee...

License and Authors
-------------------
License: GPL
Authors: grant@mapzen.com
