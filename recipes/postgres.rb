#
# Cookbook Name:: metroextractor
# Recipe:: postgres
#

package 'postgis'

%w(
  postgresql::server
  postgresql::server_dev
  postgresql::contrib
  postgresql::postgis
).each do |r|
  include_recipe r
end

# override the default postgres template
r = resources(template: "/etc/postgresql/#{node[:postgresql][:version]}/main/postgresql.conf")
r.cookbook('metroextractor')
r.source('postgresql.conf.standard.erb')

directory node[:postgresql][:data_directory] do
  action  :create
  owner   'postgres'
end

postgresql_user node[:metroextractor][:postgres][:user] do
  createdb  true
  login     true
  superuser true
  encrypted_password node[:metroextractor][:postgres][:password]
end

# drop then create the db. Ensure we're fresh on every run
#   should we need to start over in the middle for some reason.
postgresql_database node[:metroextractor][:postgres][:db] do
  action :drop
end

postgresql_database node[:metroextractor][:postgres][:db] do
  owner     node[:metroextractor][:postgres][:user]
  encoding  'utf8'
  template  'template0'
  postgis   true
end

postgresql_extension 'hstore' do
  database node[:metroextractor][:postgres][:db]
end

# force a restart up front
service 'postgresql' do
  action :restart
end
