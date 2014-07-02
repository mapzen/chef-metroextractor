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

# packages for 12.04 and 14.04
#
%w(
  build-essential
  gdal-bin
  zip
).each do |p|
  package p
end

# packages for compiling/installing imposm on 12.04.
#   use pip on <= 12.04, pkg when > 12.04
#
%w(
  libtokyocabinet-dev
  libprotobuf-dev
  protobuf-c-compiler
  protobuf-compiler
  python-dev
  python-pip
).each do |p|
  package p do
    action :install
    only_if { platform?('ubuntu') && node[:platform_version] == '12.04' && node[:metroextractor][:imposm][:major_version] == 'imposm2' }
  end
end

python_pip 'imposm' do
  version '2.5.0'
  only_if { platform?('ubuntu') && node[:platform_version] <= '12.04' && node[:metroextractor][:imposm][:major_version] == 'imposm2' }
end

package 'imposm' do
  action :install
  only_if { platform?('ubuntu') && node[:platform_version] > '12.04' && node[:metroextractor][:imposm][:major_version] == 'imposm2' }
end

ark 'imposm3' do
  owner         'root'
  url           node[:metroextractor][:imposm][:url]
  version       node[:metroextractor][:imposm][:version]
  prefix_root   node[:metroextractor][:imposm][:installdir]
  has_binaries  ['imposm3']
  only_if       { node[:metroextractor][:imposm][:major_version] == 'imposm3' }
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
  mode    0644
end

cookbook_file "#{node[:metroextractor][:setup][:scriptsdir]}/merge-geojson.py" do
  owner   node[:metroextractor][:user][:id]
  source  'merge-geojson.py'
  mode    0755
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
