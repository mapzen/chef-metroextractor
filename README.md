Metroextractor Chef
===================
[![CircleCI Build Status](https://circleci.com/gh/mapzen/chef-metroextractor.svg?style=svg)](https://circleci.com/gh/mapzen/chef-metroextractor)

Attribution
-----------
Heavily influenced by Mike Migurski's [Extractotron](https://github.com/migurski/Extractotron/)

What does it do?
----------------
Downloads the latest planet in pbf format.
Produces, via osmconvert, a number of metro extracts in both pbf and bz2 formats.
Produces shape files in both imposm and osm2pgsql formats.

Projections
-----------
GeoJSON is generated via ogr2ogr and output in CRS:84 (e.g. EPSG:4326) projection.

Imposm shapfiles are generated in EPSG:4326.

What hardware do I need?
------------------------
An m4.4xlarge is a good starting point, anything bigger will make things faster.
Enough storage for the planet file and all the extracts you plan to generate.

Usage
-----
    include_recipe 'metroextractor'

Supported Platforms
-------------------
Tested and supported on the following platforms:

* Ubuntu 14.04LTS

Requirements
------------
* Chef >= 11.4

Attributes
----------
* see [attributes/default.rb](https://github.com/mapzen/chef-metroextractor/blob/master/attributes/default.rb)

Dependencies
-----------
apt, ark, osm2pgsql, postgresql, python, user

License and Authors
-------------------
License: GPL
Authors: grant@mapzen.com
