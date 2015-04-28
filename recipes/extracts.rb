#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

bash 'osmosis' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  environment('JAVACMD_OPTIONS' => node[:metroextractor][:extracts][:osmosis_jvmopts])
  code <<-EOH
    parallel -j #{node[:metroextractor][:extracts][:osmosis_jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/osmosis.sh -d ';' --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_osmosis.log
  EOH
  timeout node[:metroextractor][:extracts][:osmosis_timeout]
  only_if { node[:metroextractor][:extracts][:process] == true }
end
