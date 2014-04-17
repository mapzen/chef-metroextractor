#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

# create a lockfile to avoid calling osmosis
#   unless force == true
#
bash 'osmosis-lock' do
  action :nothing
  code <<-EOH
    touch #{node[:metroextractor][:extracts][:osmosis_lock]}
  EOH
  not_if { node[:metroextractor][:extracts][:osmosis_force] }
end

bash 'osmosis' do
  user node[:metroextractor][:user]
  cwd  node[:metroextractor][:basedir]
  environment('JAVACMD_OPTIONS' => '-server -Xmx4G')
  code <<-EOH
    #{node[:metroextractor][:scriptsdir]}/osmosis.sh \
    >/tmp/osmosis.log 2>&1
  EOH
  timeout node[:metroextractor][:extracts][:osmosis_timeout]
  notifies :run, 'bash[osmosis-lock]', :immediately
  not_if { ::File.exist?(node[:metroextractor][:extracts][:osmosis_lock]) }
end
