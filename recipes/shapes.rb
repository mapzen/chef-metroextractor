#
# Cookbook Name:: metroextractor
# Recipe:: shapes
#

execute 'create shapes' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  command   "#{node[:metroextractor][:setup][:scriptsdir]}/shapes.sh"
  timeout   node[:metroextractor][:shapes][:osm2pgsql_timeout]
  only_if   { node[:metroextractor][:shapes][:process] == true }
end
