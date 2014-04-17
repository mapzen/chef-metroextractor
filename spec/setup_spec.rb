require 'spec_helper'

describe 'metroextractor::setup' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
  end

  %w(
    osm2pgsql::default
    osmosis::default
  ).each do |r|
    it "should include the #{r} recipe" do
      chef_run.should include_recipe r
    end
  end

  it 'should install gdal-bin' do
    chef_run.should install_package 'gdal-bin'
  end

  it 'should create the directory /opt/metroextractor-scripts' do
    chef_run.should create_directory '/opt/metroextractor-scripts'
  end

  it 'should create template /opt/metroextractor-scripts/osmosis.sh' do
    chef_run.should create_template('/opt/metroextractor-scripts/osmosis.sh').with(
      mode:   0755,
      source: 'osmosis.sh.erb'
    )
  end

  it 'should create template /opt/metroextractor-scripts/osm2pgsql.sh' do
    chef_run.should create_template('/opt/metroextractor-scripts/osm2pgsql.sh').with(
      mode:   0755,
      owner:  'postgres',
      source: 'osm2pgsql.sh.erb'
    )
  end

  it 'should create cookbook file osm2pgsql.style' do
    chef_run.should create_cookbook_file('/opt/metroextractor-scripts/osm2pgsql.style').with(
      mode:   0644,
      owner:  'postgres',
      source: 'osm2pgsql.style'
    )
  end

  it 'should create /mnt/ex' do
    chef_run.should create_directory '/mnt/ex'
  end

  it 'should create /mnt/ex/merc' do
    chef_run.should create_directory '/mnt/ex/merc'
  end

  it 'should create /mnt/ex/wgs84' do
    chef_run.should create_directory '/mnt/ex/wgs84'
  end
end
