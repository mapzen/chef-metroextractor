#
# Cookbook Name:: metroextractor
# Attributes:: default
#

# the following are booleans and tell the cookbook whether or not
#   we should produce certain types of data. Note that in order to produce
#   shapes, you MUST procuce extracts, as the former is constructed from
#   the latter.
default[:metroextractor][:shapes][:process]           = true
default[:metroextractor][:extracts][:process]         = true
default[:metroextractor][:coastlines][:process]       = true

# when the planet is updated in full or in part, create a file off of which
#   subsequent processing will be triggered
default[:metroextractor][:data][:trigger_file]        = '/etc/.metroextractor_data_trigger'

# setup
default[:metroextractor][:setup][:basedir]            = '/mnt/metro'
default[:metroextractor][:setup][:scriptsdir]         = '/opt/metroextractor-scripts'
default[:metroextractor][:setup][:cities_json_url]    = 'https://mapzen.com/data/metro-extracts/cities-extractor.json'

# user
default[:metroextractor][:user][:id]                  = 'metro'
default[:metroextractor][:user][:shell]               = '/bin/bash'
default[:metroextractor][:user][:manage_home]         = false
default[:metroextractor][:user][:create_group]        = true
default[:metroextractor][:user][:ssh_keygen]          = false

# imposm
default[:metroextractor][:imposm][:version]           = '0.2'
default[:metroextractor][:imposm][:installdir]        = '/usr/local'
default[:metroextractor][:imposm][:url]               = 'https://imposm.org/static/rel/imposm3-0.2.0dev-20160615-d495ca4-linux-x86-64.tar.gz'

# postgres
default[:metroextractor][:postgres][:db]              = 'osm'
default[:metroextractor][:postgres][:user]            = 'osm'
default[:metroextractor][:postgres][:password]        = 'password'
default[:postgresql][:data_directory]                 = '/mnt/postgres/data'
default[:postgresql][:autovacuum]                     = 'off'
default[:postgresql][:work_mem]                       = '64MB'
default[:postgresql][:temp_buffers]                   = '128MB'
default[:postgresql][:shared_buffers]                 = '8GB'
default[:postgresql][:maintenance_work_mem]           = '512MB'
default[:postgresql][:checkpoint_segments]            = '100'
default[:postgresql][:max_connections]                = '200'

# planet
default[:metroextractor][:planet][:url]               = 'http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf'
default[:metroextractor][:planet][:file]              = node[:metroextractor][:planet][:url].split('/').last
default[:metroextractor][:planet][:update]            = true  # whether to update the downloaded planet pbf with the latest changeset before processing extracts: set to true if so
default[:metroextractor][:planet_update][:timeout]    = 10_800 # 3 hours

# extracts
default[:metroextractor][:osmconvert][:timeout]       = 172_800
default[:metroextractor][:osmconvert][:jobs]          = (node[:cpu][:total] * 0.75).to_i
# hash_memory is in megs
default[:metroextractor][:osmconvert][:hash_memory]   = 1500

# shapes: note that the number of jobs below reflects close to the limit of what the
#   local postgres instance can handle in terms of max connections. Not recommended
#   to change.
default[:metroextractor][:shapes][:imposm_jobs]       = 12
default[:metroextractor][:shapes][:osm2pgsql_jobs]    = 8
default[:metroextractor][:shapes][:osm2pgsql_timeout] = 172_800

# coastlines
default[:coastlines][:generate][:timeout]             = 7_200
default[:coastlines][:water_polygons][:url]           = 'http://data.openstreetmapdata.com/water-polygons-split-4326.zip'
default[:coastlines][:land_polygons][:url]            = 'http://data.openstreetmapdata.com/land-polygons-split-4326.zip'
default[:coastlines][:water_polygons][:file]          = node[:coastlines][:water_polygons][:url].split('/').last
default[:coastlines][:land_polygons][:file]           = node[:coastlines][:land_polygons][:url].split('/').last
