#
# Cookbook Name:: metroextractor
# Recipe:: planet
#

bash 'download planet' do
  cwd  node[:metroextractor][:basedir]
  code <<-EOH
    wget --quiet #{node[:metroextractor][:planeturl]} \
    && chmod +r #{node[:metroextractor][:planetfile]}
  EOH
  not_if  { ::File.exist?("#{node[:metroextractor][:basedir]}/#{node[:metroextractor][:planetfile]}") }
end
