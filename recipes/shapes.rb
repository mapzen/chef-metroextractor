#
# Cookbook Name:: metroextractor
# Recipe:: shapes
#

file "#{node[:metroextractor][:setup][:basedir]}/.osm2pgsql.lock" do
  action :nothing
end

bash 'osm2pgsql' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    parallel --jobs #{node[:metroextractor][:shapes][:osm2pgsql_jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/osm2pgsql.sh -d ';' --joblog #{node[:metroextractor][:setup][:basedir]}/logs/paralle_osm2pgsql.log
  EOH
  timeout   node[:metroextractor][:shapes][:osm2pgsql_timeout]
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.osm2pgsql.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.osm2pgsql.lock") }
end
