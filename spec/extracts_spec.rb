require 'spec_helper'

describe 'metroextractor::extracts' do
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

  it 'should define the lockfile' do
    expect(chef_run).to_not create_file '/mnt/metro/.osmosis.lock'
  end

  it 'should run osmosis' do
    expect(chef_run).to run_bash('osmosis').with(
      user:         'metro',
      cwd:          '/mnt/metro',
      environment:  { 'JAVACMD_OPTIONS' => '-server -XX:SurvivorRatio=8 -Xms15G -Xmx15G' },
      code:         "    parallel -a /opt/metroextractor-scripts/osmosis.sh -d ';' --joblog /mnt/metro/logs/parallel_osmosis.log\n",
      timeout:      172_800
    )
  end
end
