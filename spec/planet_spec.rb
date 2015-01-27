require 'spec_helper'

describe 'metroextractor::planet' do
  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" postgres | grep osm").and_return(true)
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  it 'should download the planet md5 and notify the planet remote_file and the md5 check' do
    expect(chef_run).to create_remote_file('/mnt/metro/planet-latest.osm.pbf.md5').with(
      source: 'http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf.md5',
      backup: false,
      mode:   0644
    )

    resource = chef_run.remote_file('/mnt/metro/planet-latest.osm.pbf.md5')
    expect(resource).to notify('execute[download planet]').to(:run).immediately
    expect(resource).to notify('ruby_block[verify md5]').to(:run).immediately
  end

  it 'should not download the planet' do
    expect(chef_run).to_not run_execute('download planet')
  end

  it 'should not verify the md5' do
    expect(chef_run).to_not run_ruby_block('verify md5')
  end
end
