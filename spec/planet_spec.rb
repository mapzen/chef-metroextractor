require 'spec_helper'

describe 'metroextractor::planet' do
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
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" postgres | grep osm").and_return(true)
  end

  # it 'should download the planet' do
  #   chef_run.should create_remote_file('/mnt/metro/planet-latest.osm.pbf').with(
  #     source: 'http://ftp.heanet.ie/mirrors/openstreetmap.org/pbf/planet-latest.osm.pbf',
  #     mode:   0644
  #   )
  # end

  it 'should download the planet' do
    expect(chef_run).to run_execute('wget --quiet -O planet-latest.osm.pbf http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf').with(
      cwd:      '/mnt/metro',
      creates:  '/mnt/metro/planet-latest.osm.pbf'
    )
  end

end
