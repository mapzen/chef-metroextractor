#
# Cookbook Name:: metroextractor
# Recipe:: postgres
#

%w(
  postgresql::server
  postgresql::contrib
  postgresql::postgis
).each do |r|
  include_recipe r
end

pg_user node[:metroextractor][:postgres][:user] do
  privileges :superuser => true, :createdb => true, :login => true
  encrypted_password node[:metroextractor][:postgres][:password]
end

pg_database node[:metroextractor][:postgres][:db] do
  owner     node[:metroextractor][:postgres][:user]
  encoding  'utf8'
  template  'template0'
end

pg_database_extensions node[:metroextractor][:postgres][:db] do
  extensions  ['hstore']
  languages   'plpgsql'
  postgis     true
end
