require 'spec_helper'

describe 'metroextractor::extracts' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
  end

  it 'should define the resource osmosis-lock' do
    chef_run.should_not run_bash 'osmosis-lock'
  end

  it 'should run osmosis' do
    chef_run.should run_bash('osmosis').with(
      user:         'postgres',
      cwd:          '/mnt',
      environment:  { 'JAVACMD_OPTIONS' => '-server -Xmx4G' },
      timeout:      86_400
    )
  end

end
