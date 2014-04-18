Metroextractor Chef Cookbook
===================

Chef cookbook to automate the building of metro extracts.
Heavily influenced/borrowed from Mike Migurski's [Extractotron](https://github.com/migurski/Extractotron/)

!!! NOTE !!! Currently still in development and NOT stable

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
### metroextractor

#### basedir
Base working directory
* type: string
* default: /mnt

#### user
User to run everything as
* type: string
* default: postgres

#### scriptsdir
Where to install scripts
* type: string
* default: /opt/metroextractor-scripts

#### planeturl
Where to download the planet
Currently required to be pbf (not validated)
* type: string
* default: http://ftp.heanet.ie/mirrors/openstreetmap.org/pbf/planet-latest.osm.pbf

#### planetfile
Derive the name of the planet download from the url
Currently required to be pbf (not validated)
* type: string
* default: planeturl.split('/').last

### metroextractor.osm

#### dbs
What postgres dbs to create
* type: array
* default: [osm]

#### user
What postgres user to create
* type: string
* default: osmuser

#### password
Postgres user password
* type: string
* default: password

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
JVM options to pass to osmosis
* type: string
* default: '-server -Xmx8G'

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
Fork, create a feature branch, send a pull! Weeee...

License and Authors
-------------------
License: GPL
Authors: grant@mapzen.com
