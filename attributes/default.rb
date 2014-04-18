#
# Cookbook Name:: metroextractor
# Attributes:: default
#

# metroextractor
default[:metroextractor][:basedir]      = '/mnt'
default[:metroextractor][:user]         = 'postgres'
default[:metroextractor][:scriptsdir]   = '/opt/metroextractor-scripts'

# planet
default[:metroextractor][:planeturl]  = 'http://ftp.heanet.ie/mirrors/openstreetmap.org/pbf/planet-latest.osm.pbf'
default[:metroextractor][:planetfile] = node[:metroextractor][:planeturl].split('/').last

# postgres
default[:metroextractor][:osm][:dbs]      = %w(osm)
default[:metroextractor][:osm][:user]     = 'osmuser'
default[:metroextractor][:osm][:password] = 'password'

# processing
default[:metroextractor][:extracts][:osmosis_timeout] = 172_800
default[:metroextractor][:extracts][:osmosis_force]   = nil
default[:metroextractor][:extracts][:osmosis_jvmopts] = '-server -Xmx8G'
default[:metroextractor][:extracts][:osmosis_lock]    = "#{node[:metroextractor][:basedir]}/.osmosis.lock"

# osmosis
default[:osmosis][:symlink]      = true
default[:osmosis][:install_type] = 'tgz'
