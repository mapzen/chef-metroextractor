require 'spec_helper'

describe 'metroextractor::planet' do

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
  end

  it 'should download the planet' do
    chef_run.should run_bash('download planet').with(
      cwd: '/mnt'
    )
  end

end
