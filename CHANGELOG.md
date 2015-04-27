metroextractor changelog
========================

0.16.0
------
* allow application of changesets to the planet before processing extracts

0.15.0
------
* maintain custom mapping for imposm3
  * custom mapping adds neighborhoods

0.14.0
------
* add hstore to osm2pgsql run

0.13.14
-------
* lint coastlines.sh

0.13.13
-------
* lint

0.13.12
-------
* fix encoding issue with geojson generated from shp files

0.13.11
-------
* build coastline extract data from land and water polygons

0.13.8
------
* replace remote_file for planet download with wget: remote_file is too slow and flaky for files this large

0.13.7
------
* lower default heap size to 2G per osmosis processes

0.13.6
------
* make the planet download trigger off the md5 remote_file resource. If the md5 hasn't changed, we won't
  go through the trouble of downloading the planet again.
* calculate the md5 of the downloaded planet file and compare it against the provided md5sum

0.13.5
------
* :create the planet_remote file to allow use on stateful systems (i.e. non instance store)
* don't back up the planet file when we get a new one

0.13.4
------
* replace chef-rewind with resource override

0.13.3
------
* imposm parallel job tuning

0.13.2
------
* PG tuning

0.13.1
------
* break out parallel_jobs into two attributes: imposm_jobs and osm2pgsql_jobs, for more granular tuning

0.13.0
------
* update shapes and extracts to use gnu parallel: provide better logging
  and better error handling.

0.12.0
------
* go back to using remote_file to fetch the planet pbf

0.11.11
-------
* include branch in metroextractor-cities git pull, to allow override

0.11.10
-------
* don't re-sync the cities repo if we've already cloned it once, to avoid pulling in changes we
  aren't potentially expecting if we abort and re-start a run

0.11.9
------
* slice count

0.11.8
------
* drop the pg db during a re-run

0.11.7
------
* fewer slices

0.11.6
------
* pg max connections

0.11.5
------
* increase checkpoint_segments

0.11.4
------
* drop osm2pgsql num procs

0.11.3
------
* set slice count to cpu total

0.11.2
------
* read pbf rather than bz2 for osm2pgsql
* back to smaller slice size
* increase workers for osm2pgsql
* increase node cache for osm2pgsql

0.11.1
------
* use larger slices

0.11.0
------
* process shapes (osm2psql) in batches (default 8)

0.10.6
------
* node cache for osmosis

0.10.5
------
* fix osmosis heap setup

0.10.4
------
* allow download to linger for up to 2 hours

0.10.3
------
* limit osmosis heap size (per instance) via .osmosis conf file

0.10.2
------
* download url change

0.10.1
------
* osmosis buffer size

0.10.0
------
* big bump for osmosis changes

0.9.5
-----
* bug fixes

0.9.4
-----
* experiment with multiple osmosis processes, one per region

0.9.3
-----
* more workers for osmosis

0.9.2
-----
* remove hardcoded db/user/password in osm2pgsql.sh

0.9.1
-----
* need to support both imposm2/3 in osm2pgsql.sh

0.9.0
-----
* use imposm3
* TODO: specs for all the variations in setup.rb

0.8.4
-----
* test osm2pgsql.sh with osm2pgsql/imposm commands being run in series rather than parallel (hangs)

0.8.3
-----
* clean up imposm install logic

0.8.1
-----
* clean up pkg installs for 12.04 vs 14.04
* specs

0.8.0
-----
* tested on Ubuntu 14.04LTS
* on 12.04, continue installing imposm via pip, use pkg on 14.04

0.7.13
------
* don't merge osm2pgsql geojson this way. Disable for now.

0.7.12
------
* remove unnecessary 'rm' from cleanup in osm2pgsql.sh

0.7.11
------
* use DROP ... CASCADE

0.7.10
-----
* use execute rather than bash for planet download
* use --quiet

0.7.9
-----
* download planet with wget, remote_file is insanely slow with large files

0.7.8
-----
* speed up osmosis: set workers, buffers

0.7.7
-----
* remove compress=none from osmosis, as it doesn't appear to have any real effect
  on performance (speed), so might as well keep file size down

0.7.6
-----
* be explicit about modes
* set correct mode for merge script

0.7.5
-----
* override the source projection (-s_srs epsg:900913) for imposm geojson creation
  * should resolve issue https://github.com/mapzen/metroextractor-cities/issues/17

0.7.4
-----
* set compress=none in osmosis output. Per the docs, files should write twice as fast
  at the expense of 2x space requirement

0.7.3
-----
* add omitmetadata to osmosis cmd line

0.7.2
-----
* DROP VIEW should be DROP TABLE in osm2pgsql.sh

0.7.1
-----
* merge osm2pgsql geojson output into a single file

0.7.0
-----
* install imposm via pip to get latest 2.x release, in hopes of 
  resolving an ongoing imposm bug (hangs)

0.6.9
-----
* clean up osm2pgsql.sh

0.6.8
-----
* more fixes for geojson output
* add geojson for imposm shp files

0.6.7
-----
* bug fix for geojson output

0.6.6
-----
* bug fix in shapes.rb for lockfile

0.6.5
-----
* lock the planet download

0.6.4
-----
* osm2pgsql.sh fix: function, not funtion (!)

0.6.3
-----
* add geojson output

0.6.2
-----
* add clipIncompleteEntities=true to bounding box statements in osmosis.sh 
  to avoid dangling references

0.6.1
-----
* use localhost in osm2pgsql.sh

0.6.0
-----
* break out cities.json into its own repository

0.5.1
-----
* brisbane, perth, darwin...

0.5.0
-----
* fixes to allow easier overrides

0.4.2
-----
* bug fix in postgres template

0.4.1
-----
* restart postgres immediately

0.4.0
-----
* rewind the default postgres template
* apply more postgres tuning

0.3.2
-----
* turn off autovacuum
* checkpoint segments

0.3.1
-----
* add avignon to cities.json

0.3.0
-----
* override default postgres data dir to avoid running out of space

0.2.1
-----
* use array in osm2pgsql.sh

0.2.0
-----
* drive osm2pgsql/osmosis off a single json config file: cities.txt

0.1.1
-----
* stable
