require 'spec_helper'

describe 'metroextractor::postgres' do
  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osm'\" | grep osm").and_return(true)
    stub_command('test -f /mnt/metro/pg_data/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" postgres | grep osm").and_return(true)
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  it 'should install the package postgis' do
    expect(chef_run).to install_package 'postgis'
  end

  it 'should create the postgres data directory' do
    expect(chef_run).to create_directory('/mnt/metro/pg_data').with(
      owner: 'postgres'
    )
  end

  it 'should create template postgresql.conf' do
    expect(chef_run).to create_template('/etc/postgresql/9.3/main/postgresql.conf').with(
      source:   'postgresql.conf.standard.erb',
      cookbook: 'metroextractor',
      owner:    'postgres',
      group:    'postgres'
    )
  end

  it 'should restart postgres' do
    expect(chef_run).to restart_service 'postgresql'
  end
end
