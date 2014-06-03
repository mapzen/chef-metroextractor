metroextractor CHANGELOG
========================

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
