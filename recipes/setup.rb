#
# Cookbook Name:: metroextractor
# Recipe:: setup
#

%w(
  osm2pgsql::default
  osmosis::default
).each do |r|
  include_recipe r
end

# packages
#
%w(
  gdal-bin
  imposm
  zip
).each do |p|
  package p
end

# scripts
#
directory node[:metroextractor][:setup][:scriptsdir] do
  owner node[:metroextractor][:user][:id]
end

cookbook_file "#{node[:metroextractor][:setup][:scriptsdir]}/cities.json" do
  owner   node[:metroextractor][:user][:id]
  source  'cities.json'
end

template "#{node[:metroextractor][:setup][:scriptsdir]}/osmosis.sh" do
  owner   node[:metroextractor][:user][:id]
  source  'osmosis.sh.erb'
  mode    0755
end

template "#{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.sh" do
  owner   node[:metroextractor][:user][:id]
  source  'osm2pgsql.sh.erb'
  mode    0755
end

cookbook_file "#{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.style" do
  owner   node[:metroextractor][:user][:id]
  source  'osm2pgsql.style'
end

# directories for extracts and logs
#
directory "#{node[:metroextractor][:setup][:basedir]}/ex" do
  owner node[:metroextractor][:user][:id]
end

directory "#{node[:metroextractor][:setup][:basedir]}/logs" do
  owner node[:metroextractor][:user][:id]
end

# directories for shapes
#
directory "#{node[:metroextractor][:setup][:basedir]}/shp" do
  owner node[:metroextractor][:user][:id]
end
