#
# Cookbook Name:: metroextractor
# Recipe:: planet
#

# override tempfile location so the planet download
#   temp file goes somewhere with enough space
ENV['TMP'] = node[:metroextractor][:setup][:basedir]

# fail if someone tries to pull something other than
#   a pbf data file
fail if node[:metroextractor][:planet][:file] !~ /\.pbf$/

remote_file "#{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]}.md5" do
  action    :create
  backup    false
  source    "#{node[:metroextractor][:planet][:url]}.md5"
  mode      0644
  notifies  :run, 'execute[download planet]', :immediately
  notifies  :run, 'ruby_block[verify md5]',   :immediately
end

execute 'download planet' do
  action  :nothing
  command "wget --quiet -O #{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]} #{node[:metroextractor][:planet][:url]}"
  user    node[:metroextractor][:user][:id]
end

ruby_block 'verify md5' do
  action :nothing

  block do
    require 'digest'

    planet_md5  = Digest::MD5.file("#{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]}").hexdigest
    md5         = File.read("#{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]}.md5").split(' ').first

    if planet_md5 != md5
      Chef::Log.info('Failure: the md5 of the planet we downloaded does not appear to be correct. Aborting.')
      abort
    end
  end
end

include_recipe 'metroextractor::planet_update' if node[:metroextractor][:planet][:update] == true
