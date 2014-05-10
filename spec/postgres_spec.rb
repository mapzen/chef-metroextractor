require 'spec_helper'

describe 'metroextractor::postgres' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osm'\" | grep osm").and_return(true)
    stub_command('test -f /mnt/metro/pg_data/PG_VERSION').and_return(true)
  end

  it 'should create the postgres data directory' do
    chef_run.should create_directory('/mnt/metro/pg_data').with(
      owner: 'postgres'
    )
  end

  it 'should install chef_gem chef-rewind' do
    chef_run.should install_chef_gem 'chef-rewind'
  end

  it 'should create template postgresql.conf' do
    chef_run.should create_template('/etc/postgresql/9.3/main/postgresql.conf').with(
      source:   'postgresql.conf.standard.erb',
      cookbook: 'metroextractor',
      owner:    'postgres',
      group:    'postgres',
      mode:     0644
    )
  end

  it 'should restart postgres' do
    chef_run.should restart_service 'postgresql'
  end

end
