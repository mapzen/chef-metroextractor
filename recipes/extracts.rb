#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

# create a lockfile to avoid calling osmosis
#   unless force == true
#
file node[:metroextractor][:extracts][:osmosis_lock] do
  action :nothing
end

file node[:metroextractor][:extracts][:osmosis_lock] do
  action  :delete
  only_if { node[:metroextractor][:extracts][:osmosis_force] }
end

bash 'osmosis' do
  user node[:metroextractor][:user]
  cwd  node[:metroextractor][:basedir]
  environment('JAVACMD_OPTIONS' => node[:metroextractor][:extracts][:osmosis_jvmopts])
  code <<-EOH
    #{node[:metroextractor][:scriptsdir]}/osmosis.sh \
    >/tmp/osmosis.log 2>&1
  EOH
  timeout node[:metroextractor][:extracts][:osmosis_timeout]
  notifies :create, "file[#{node[:metroextractor][:extracts][:osmosis_lock]}]", :immediately
  not_if { ::File.exist?(node[:metroextractor][:extracts][:osmosis_lock]) }
end
