#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

file "#{node[:metroextractor][:setup][:basedir]}/.osmosis.lock" do
  action :nothing
end

bash 'osmosis' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  environment('JAVACMD_OPTIONS' => node[:metroextractor][:extracts][:osmosis_jvmopts])
  code <<-EOH
    parallel -a #{node[:metroextractor][:setup][:scriptsdir]}/osmosis.sh --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_osmosis.log
  EOH
  timeout   node[:metroextractor][:extracts][:osmosis_timeout]
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.osmosis.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.osmosis.lock") }
end
