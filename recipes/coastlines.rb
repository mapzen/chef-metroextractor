#
# Cookbook Name:: metroextractor
# Recipe:: coastlines
#

execute 'wget water polygons' do
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  command <<-EOH
    wget --quiet -O #{node[:coastlines][:water_polygons][:file]} \
      #{node[:coastlines][:water_polygons][:url]} &&
      unzip #{node[:coastlines][:water_polygons][:file]}
  EOH
  not_if  { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/#{node[:coastlines][:water_polygons][:file]}") }
  only_if { node[:metroextractor][:coastlines][:process] == true }
end

execute 'wget land polygons' do
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  command <<-EOH
    wget --quiet -O #{node[:coastlines][:land_polygons][:file]} \
      #{node[:coastlines][:land_polygons][:url]} &&
      unzip #{node[:coastlines][:land_polygons][:file]}
  EOH
  not_if  { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/#{node[:coastlines][:land_polygons][:file]}") }
  only_if { node[:metroextractor][:coastlines][:process] == true }
end

execute 'generate coastlines' do
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  timeout node[:coastlines][:generate][:timeout]
  command <<-EOH
    #{node[:metroextractor][:setup][:scriptsdir]}/coastlines.sh \
      >#{node[:metroextractor][:setup][:basedir]}/logs/coastlines.log 2>&1
  EOH
  only_if { node[:metroextractor][:coastlines][:process] == true }
end
