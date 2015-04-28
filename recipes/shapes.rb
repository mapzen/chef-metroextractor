#
# Cookbook Name:: metroextractor
# Recipe:: shapes
#

execute 'osm2pgsql' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  command   "#{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.sh"
  timeout   node[:metroextractor][:shapes][:osm2pgsql_timeout]
  only_if   { node[:metroextractor][:shapes][:process] == true }
end
