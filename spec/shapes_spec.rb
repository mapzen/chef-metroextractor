require 'spec_helper'

describe 'metroextractor::shapes' do
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
  end

  it 'should define the lockfile' do
    chef_run.should_not create_file '/mnt/metro/.osm2pgsql.lock'
  end

  it 'should run osm2pgsql' do
    chef_run.should run_bash('osm2pgsql').with(
      user:         'metro',
      cwd:          '/mnt/metro',
      timeout:      172_800
    )
  end

end
