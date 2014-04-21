#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

file node[:metroextractor][:extracts][:osmosis_lock] do
  action  :nothing
end

bash 'osmosis' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  environment('JAVACMD_OPTIONS' => node[:metroextractor][:extracts][:osmosis_jvmopts])
  code <<-EOH
    #{node[:metroextractor][:setup][:scriptsdir]}/osmosis.sh \
    >#{node[:metroextractor][:setup][:basedir]}/logs/osmosis.log 2>&1
  EOH
  timeout node[:metroextractor][:extracts][:osmosis_timeout]
  notifies :create, "file[#{node[:metroextractor][:extracts][:osmosis_lock]}]", :immediately
  not_if { ::File.exist?(node[:metroextractor][:extracts][:osmosis_lock]) }
end
