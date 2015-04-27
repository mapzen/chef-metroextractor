#
# Cookbook Name:: metroextractor
# Attributes:: default
#

# setup
default[:metroextractor][:setup][:basedir]            = '/mnt/metro'
default[:metroextractor][:setup][:scriptsdir]         = '/opt/metroextractor-scripts'
default[:metroextractor][:setup][:cities_repo]        = 'https://github.com/mapzen/metroextractor-cities.git'
default[:metroextractor][:setup][:cities_branch]      = 'master'

# user
default[:metroextractor][:user][:id]                  = 'metro'
default[:metroextractor][:user][:shell]               = '/bin/bash'
default[:metroextractor][:user][:manage_home]         = false
default[:metroextractor][:user][:create_group]        = true
default[:metroextractor][:user][:ssh_keygen]          = false

# imposm
default[:metroextractor][:imposm][:major_version]     = 'imposm3'
default[:metroextractor][:imposm][:version]           = '0.1'
default[:metroextractor][:imposm][:url]               = 'http://imposm.org/static/rel/imposm3-0.1dev-20140702-ced9f92-linux-x86-64.tar.gz'
default[:metroextractor][:imposm][:installdir]        = '/usr/local'

# postgres
default[:metroextractor][:postgres][:db]              = 'osm'
default[:metroextractor][:postgres][:user]            = 'osm'
default[:metroextractor][:postgres][:password]        = 'password'
default[:postgresql][:data_directory]                 = "#{node[:metroextractor][:setup][:basedir]}/pg_data"
default[:postgresql][:autovacuum]                     = 'off'
default[:postgresql][:work_mem]                       = '64MB'
default[:postgresql][:temp_buffers]                   = '128MB'
default[:postgresql][:shared_buffers]                 = '8GB'
default[:postgresql][:maintenance_work_mem]           = '512MB'
default[:postgresql][:checkpoint_segments]            = '50'
default[:postgresql][:max_connections]                = '200'

# planet
default[:metroextractor][:planet][:url]               = 'http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf'
default[:metroextractor][:planet][:file]              = node[:metroextractor][:planet][:url].split('/').last
default[:metroextractor][:planet][:update]            = nil  # whether to update the downloaded planet pbf with the latest changeset before processing extracts: set to true if so
default[:metroextractor][:planet_update][:timeout]    = 10_800 # 3 hours

# extracts
default[:metroextractor][:extracts][:osmosis_timeout] = 172_800

# set osmosis heap (per process!!!)
heap                                                  = '10G'
default[:metroextractor][:extracts][:osmosis_jvmopts] = "-server -XX:SurvivorRatio=8 -Xms#{heap} -Xmx#{heap}"

# shapes
default[:metroextractor][:shapes][:imposm_jobs]       = 12
default[:metroextractor][:shapes][:osm2pgsql_jobs]    = 8
default[:metroextractor][:shapes][:osm2pgsql_timeout] = 172_800

# osmosis
default[:osmosis][:install_type]                      = 'tgz'

# coastlines
default[:coastlines][:generate][:timeout]             = 7_200
default[:coastlines][:water_polygons][:url]           = 'http://data.openstreetmapdata.com/water-polygons-split-4326.zip'
default[:coastlines][:land_polygons][:url]            = 'http://data.openstreetmapdata.com/land-polygons-split-4326.zip'
default[:coastlines][:water_polygons][:file]          = node[:coastlines][:water_polygons][:url].split('/').last
default[:coastlines][:land_polygons][:file]           = node[:coastlines][:land_polygons][:url].split('/').last
