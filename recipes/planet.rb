#
# Cookbook Name:: metroextractor
# Recipe:: planet
#

# override tempfile location so the planet download
#   temp file goes somewhere with enough space
#
ENV['TMP'] = node[:metroextractor][:setup][:basedir]

# lockfile
#
file "#{node[:metroextractor][:setup][:basedir]}/.planet.lock" do
  action :nothing
end

# fail if someone tries to pull something other than
#   a pbf data file
fail if node[:metroextractor][:planet][:file] !~ /\.pbf$/

remote_file "#{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]}" do
  source    node[:metroextractor][:planet][:url]
  mode      0644
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.planet.lock]", :immediately
  not_if { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.planet.lock") }
end
