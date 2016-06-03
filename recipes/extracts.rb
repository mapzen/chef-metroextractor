#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

execute 'osmconvert planet' do
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  timeout node[:metroextractor][:osmconvert][:timeout]
  command <<-EOH
    osmconvert #{node[:metroextractor][:planet][:file]} -o=planet.o5m \
      >#{node[:metroextractor][:setup][:basedir]}/logs/osmconvert_planet.log 2>&1
  EOH
  only_if { node[:metroextractor][:extracts][:process] == true && ::File.exist?(node[:metroextractor][:data][:trigger_file]) }
end

execute 'create extracts' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:osmconvert][:timeout]
  notifies  :run, 'execute[fix osmconvert perms]', :immediately
  command <<-EOH
    parallel -j #{node[:metroextractor][:osmconvert][:jobs]} \
      -a #{node[:metroextractor][:setup][:scriptsdir]}/extracts.sh \
      --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_osmconvert.log
  EOH
  only_if { node[:metroextractor][:extracts][:process] == true }
end

execute 'fix osmconvert perms' do
  action    :nothing
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  command   'chmod 644 ex/*'
  only_if   { node[:metroextractor][:extracts][:process] == true }
end
