#
# Cookbook Name:: metroextractor
# Recipe:: setup
#

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
directory node[:metroextractor][:setup][:scriptsdir] do
  owner node[:metroextractor][:user][:id]
end

template "#{node[:metroextractor][:setup][:scriptsdir]}/osmosis.sh" do
  mode    0755
  owner   node[:metroextractor][:user][:id]
  source  'osmosis.sh.erb'
end

# directories for extracts and logs
#
directory "#{node[:metroextractor][:setup][:basedir]}/ex" do
  owner node[:metroextractor][:user][:id]
end

directory "#{node[:metroextractor][:setup][:basedir]}/logs" do
  owner node[:metroextractor][:user][:id]
end
