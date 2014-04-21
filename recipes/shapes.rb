#
# Cookbook Name:: metroextractor
# Recipe:: shapes
#

file node[:metroextractor][:shapes][:osm2pgsql_lock] do
  action  :nothing
end

bash 'osm2pgsql' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    #{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.sh \
    >#{node[:metroextractor][:setup][:basedir]}/logs/osm2pgsql.log 2>&1
  EOH
  timeout node[:metroextractor][:shapes][:osm2pgsql_timeout]
  notifies :create, "file[#{node[:metroextractor][:shapes][:osm2pgsql_lock]}]", :immediately
  not_if { ::File.exist?(node[:metroextractor][:shapes][:osm2pgsql_lock]) }
end
