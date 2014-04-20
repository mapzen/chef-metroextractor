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
).each do |p|
  package p
end

# scripts
#
directory node[:metroextractor][:setup][:scriptsdir] do
  owner node[:metroextractor][:user][:id]
  group 'postgres'
  mode  0775
end

template "#{node[:metroextractor][:setup][:scriptsdir]}/osmosis.sh" do
  owner   node[:metroextractor][:user][:id]
  group   'postgres'
  source  'osmosis.sh.erb'
  mode    0775
end

template "#{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.sh" do
  owner   node[:metroextractor][:user][:id]
  group   'postgres'
  source  'osm2pgsql.sh.erb'
  mode    0775
end

cookbook_file "#{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.style" do
  owner   node[:metroextractor][:user][:id]
  group   'postgres'
  source  'osm2pgsql.style'
  mode    0664
end

# directories for extracts and logs
#
directory "#{node[:metroextractor][:setup][:basedir]}/ex" do
  owner node[:metroextractor][:user][:id]
  group 'postgres'
  mode  0775
end

directory "#{node[:metroextractor][:setup][:basedir]}/logs" do
  owner node[:metroextractor][:user][:id]
  group 'postgres'
  mode  0775
end
