#
# Cookbook Name:: metroextractor
# Recipe:: shapes
#

file "#{node[:metroextractor][:setup][:basedir]}/.osm2pgsql.lock" do
  action :nothing
end

execute 'osm2pgsql' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  command "#{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.sh"
  timeout   node[:metroextractor][:shapes][:osm2pgsql_timeout]
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.osm2pgsql.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.osm2pgsql.lock") }
end
