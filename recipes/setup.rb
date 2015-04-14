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
  parallel
  zip
  git
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
  revision    node[:metroextractor][:setup][:cities_branch]
  user        node[:metroextractor][:user][:id]
  not_if      { ::File.directory?("#{node[:metroextractor][:setup][:scriptsdir]}/metroextractor-cities") }
end

link "#{node[:metroextractor][:setup][:scriptsdir]}/cities.json" do
  to "#{node[:metroextractor][:setup][:scriptsdir]}/metroextractor-cities/cities.json"
end

# scripts
#
%w(osmosis.sh osm2pgsql.sh coastlines.sh).each do |t|
  template "#{node[:metroextractor][:setup][:scriptsdir]}/#{t}" do
    owner   node[:metroextractor][:user][:id]
    source  "#{t}.erb"
    mode    0755
  end
end

%w(osm2pgsql.style merge-geojson.py mapping.json).each do |f|
  cookbook_file "#{node[:metroextractor][:setup][:scriptsdir]}/#{f}" do
    owner   node[:metroextractor][:user][:id]
    source  f
    mode    0644
  end
end

%w(ex logs shp coast).each do |d|
  directory "#{node[:metroextractor][:setup][:basedir]}/#{d}" do
    owner node[:metroextractor][:user][:id]
  end
end
