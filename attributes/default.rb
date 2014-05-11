#
# Cookbook Name:: metroextractor
# Attributes:: default
#

# setup
default[:metroextractor][:setup][:basedir]      = '/mnt/metro'
default[:metroextractor][:setup][:scriptsdir]   = '/opt/metroextractor-scripts'

# user
default[:metroextractor][:user][:id]            = 'metro'
default[:metroextractor][:user][:shell]         = '/bin/bash'
default[:metroextractor][:user][:manage_home]   = false
default[:metroextractor][:user][:create_group]  = true
default[:metroextractor][:user][:ssh_keygen]    = false

# postgres
default[:metroextractor][:postgres][:db]        = 'osm'
default[:metroextractor][:postgres][:user]      = 'osm'
default[:metroextractor][:postgres][:password]  = 'password'
default[:postgresql][:data_directory]           = "#{node[:metroextractor][:setup][:basedir]}/pg_data"
default[:postgresql][:autovacuum]               = 'off'
default[:postgresql][:work_mem]                 = '64MB'
default[:postgresql][:temp_buffers]             = '128MB'
default[:postgresql][:shared_buffers]           = '1GB'
default[:postgresql][:maintenance_work_mem]     = '1GB'
default[:postgresql][:checkpoint_segments]      = '20'

# planet
default[:metroextractor][:planet][:url]  = 'http://ftp.heanet.ie/mirrors/openstreetmap.org/pbf/planet-latest.osm.pbf'
default[:metroextractor][:planet][:file] = node[:metroextractor][:planet][:url].split('/').last

# extracts
default[:metroextractor][:extracts][:osmosis_timeout] = 172_800

# set osmosis heap to half available ram
heap  = "#{(node[:memory][:total].to_i * 0.6).floor / 1024}M"
default[:metroextractor][:extracts][:osmosis_jvmopts] = "-server -XX:SurvivorRatio=8 -Xms#{heap} -Xmx#{heap}"

# shapes
default[:metroextractor][:shapes][:osm2pgsql_timeout] = 172_800

# osmosis
default[:osmosis][:symlink]      = true
default[:osmosis][:install_type] = 'tgz'
