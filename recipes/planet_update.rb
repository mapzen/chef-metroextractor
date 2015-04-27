#
# Cookbook Name:: metroextractor
# Recipe:: planet_update
#

package 'osmctools'

execute 'update planet' do
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  command <<-EOH
    osmupdate #{node[:metroextractor][:planet][:file]} updated-#{node[:metroextractor][:planet][:file]} &&
    rm #{node[:metroextractor][:planet][:file]} &&
    mv updated-#{node[:metroextractor][:planet][:file]} #{node[:metroextractor][:planet][:file]}
  EOH
  timeout node[:metroextractor][:planet_update][:timeout]
end
