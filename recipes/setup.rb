#
# Cookbook Name:: metroextractor
# Recipe:: setup
#

include_recipe 'osm2pgsql::default'
include_recipe 'osmosis::default'

# packages
#
%w(
  gdal-bin
).each do |p|
  package p
end

# scripts
#
directory node[:metroextractor][:scriptsdir] do
  owner 'postgres'
end

template "#{node[:metroextractor][:scriptsdir]}/osmosis.sh" do
  mode    0755
  owner   'postgres'
  source  'osmosis.sh.erb'
end

template "#{node[:metroextractor][:scriptsdir]}/osm2pgsql.sh" do
  mode    0755
  owner   'postgres'
  source  'osm2pgsql.sh.erb'
end

cookbook_file "#{node[:metroextractor][:scriptsdir]}/osm2pgsql.style" do
  mode    0644
  owner   'postgres'
  source  'osm2pgsql.style'
end

# directories for shapes and extracts
#
directory "#{node[:metroextractor][:basedir]}/ex" do
  owner node[:metroextractor][:user]
end

directory "#{node[:metroextractor][:basedir]}/ex/merc" do
  owner node[:metroextractor][:user]
end

directory "#{node[:metroextractor][:basedir]}/ex/wgs84" do
  owner node[:metroextractor][:user]
end
