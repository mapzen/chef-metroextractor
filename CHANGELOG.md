metroextractor changelog
========================

0.7.13
------
- don't merge osm2pgsql geojson this way. Disable for now.

0.7.12
------
- remove unnecessary 'rm' from cleanup in osm2pgsql.sh

0.7.11
------
- use DROP ... CASCADE

0.7.10
-----
- use execute rather than bash for planet download
- use --quiet

0.7.9
-----
- download planet with wget, remote_file is insanely slow with large files

0.7.8
-----
- speed up osmosis: set workers, buffers

0.7.7
-----
- remove compress=none from osmosis, as it doesn't appear to have any real effect
  on performance (speed), so might as well keep file size down

0.7.6
-----
- be explicit about modes
- set correct mode for merge script

0.7.5
-----
- override the source projection (-s_srs epsg:900913) for imposm geojson creation
  - should resolve issue https://github.com/mapzen/metroextractor-cities/issues/17

0.7.4
-----
- set compress=none in osmosis output. Per the docs, files should write twice as fast
  at the expense of 2x space requirement

0.7.3
-----
- add omitmetadata to osmosis cmd line

0.7.2
-----
- DROP VIEW should be DROP TABLE in osm2pgsql.sh

0.7.1
-----
- merge osm2pgsql geojson output into a single file

0.7.0
-----
- install imposm via pip to get latest 2.x release, in hopes of 
  resolving an ongoing imposm bug (hangs)

0.6.9
-----
- clean up osm2pgsql.sh

0.6.8
-----
- more fixes for geojson output
- add geojson for imposm shp files

0.6.7
-----
- bug fix for geojson output

0.6.6
-----
- bug fix in shapes.rb for lockfile

0.6.5
-----
- lock the planet download

0.6.4
-----
- osm2pgsql.sh fix: function, not funtion (!)

0.6.3
-----
- add geojson output

0.6.2
-----
- add clipIncompleteEntities=true to bounding box statements in osmosis.sh 
  to avoid dangling references

0.6.1
-----
- use localhost in osm2pgsql.sh

0.6.0
-----
- break out cities.json into its own repository

0.5.1
-----
- brisbane, perth, darwin...

0.5.0
-----
- fixes to allow easier overrides

0.4.2
-----
- bug fix in postgres template

0.4.1
-----
- restart postgres immediately

0.4.0
-----
- rewind the default postgres template
- apply more postgres tuning

0.3.2
-----
- turn off autovacuum
- checkpoint segments

0.3.1
-----
- add avignon to cities.json

0.3.0
-----
- override default postgres data dir to avoid running out of space

0.2.1
-----
- use array in osm2pgsql.sh

0.2.0
-----
- drive osm2pgsql/osmosis off a single json config file: cities.txt

0.1.1
-----
- stable
