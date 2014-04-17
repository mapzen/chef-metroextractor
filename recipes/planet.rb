#
# Cookbook Name:: metroextractor
# Recipe:: planet
#

# override tempfile location so the planet download
#   temp file goes somewhere with enough space
#
# ENV['TMP'] = node[:metroextractor][:basedir]

remote_file "#{node[:metroextractor][:basedir]}/#{node[:metroextractor][:planetfile]}" do
  source node[:metroextractor][:planeturl]
  mode   0644
end
