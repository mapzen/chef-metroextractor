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
  libtokyocabinet-dev
  libprotobuf-dev
  protobuf-c-compiler
  protobuf-compiler
  python-dev
  python-pip
  zip
).each do |p|
  package p
end

# scripts basedir
#
directory node[:metroextractor][:setup][:scriptsdir] do
  owner node[:metroextractor][:user][:id]
end

# cities
#
git "#{node[:metroextractor][:setup][:scriptsdir]}/metroextractor-cities" do
  action      :sync
  repository  node[:metroextractor][:setup][:cities_repo]
  user        node[:metroextractor][:user][:id]
end

link "#{node[:metroextractor][:setup][:scriptsdir]}/cities.json" do
  to "#{node[:metroextractor][:setup][:scriptsdir]}/metroextractor-cities/cities.json"
end

# scripts
#
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

# compile imposm
#
python_pip 'imposm' do
  version '2.5.0'
end
