#
# Cookbook Name:: metroextractor
# Recipe:: setup
#

include_recipe 'osm2pgsql::default'

%w(
  build-essential
  osmctools
  gdal-bin
  parallel
  zip
  git
).each do |p|
  package p
end

# imposm
ark 'imposm3' do
  owner         'root'
  url           node[:metroextractor][:imposm][:url]
  version       node[:metroextractor][:imposm][:version]
  prefix_root   node[:metroextractor][:imposm][:installdir]
  has_binaries  ['imposm3']
end

# scripts basedir
directory node[:metroextractor][:setup][:scriptsdir] do
  owner node[:metroextractor][:user][:id]
end

# cities
git "#{node[:metroextractor][:setup][:scriptsdir]}/metroextractor-cities" do
  action      :sync
  repository  node[:metroextractor][:setup][:cities_repo]
  revision    node[:metroextractor][:setup][:cities_branch]
  user        node[:metroextractor][:user][:id]
end

link "#{node[:metroextractor][:setup][:scriptsdir]}/cities.json" do
  to "#{node[:metroextractor][:setup][:scriptsdir]}/metroextractor-cities/cities.json"
end

# vex
if node[:metroextractor][:extracts][:backend] == 'vex'
  package 'libprotobuf-c0-dev'
  package 'zlib1g-dev'
  package 'clang'

  ark 'vex' do
    owner        'root'
    url          node[:metroextractor][:vex][:url]
    version      node[:metroextractor][:vex][:version]
    prefix_root  node[:metroextractor][:vex][:installdir]
    has_binaries ['vex']
    notifies     :run, 'execute[build vex]', :immediately
  end

  execute 'build vex' do
    action  :nothing
    cwd     "#{node[:metroextractor][:vex][:installdir]}/vex-#{node[:metroextractor][:vex][:version]}"
    command "make -j#{node[:cpu][:total]}"
  end

  directory node[:metroextractor][:vex][:db] do
    recursive true
    owner     node[:metroextractor][:user][:id]
    not_if    { node[:metroextractor][:vex][:db] == 'memory' }
  end
end

# scripts
%w(extracts_vex.sh extracts_osmconvert.sh shapes.sh coastlines.sh).each do |t|
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
