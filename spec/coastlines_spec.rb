require 'spec_helper'

describe 'metroextractor::coastlines' do
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
    expect(chef_run).to_not create_file '/mnt/metro/.coastlines.lock'
  end

  it 'should wget water polygons' do
    expect(chef_run).to run_bash('wget water polygons').with(
      user: 'metro',
      cwd:  '/mnt/metro',
      code: "    wget --quiet -O water-polygons-split-4326.zip http://data.openstreetmapdata.com/water-polygons-split-4326.zip && unzip water-polygons-split-4326.zip\n"
    )
  end

  it 'should wget land polygons' do
    expect(chef_run).to run_bash('wget land polygons').with(
      user: 'metro',
      cwd:  '/mnt/metro',
      code: "    wget --quiet -O land-polygons-split-4326.zip http://data.openstreetmapdata.com/land-polygons-split-4326.zip && unzip land-polygons-split-4326.zip\n"
    )
  end

  it 'should generate coastlines' do
    expect(chef_run).to run_bash('generate coastlines').with(
      user: 'metro',
      cwd:  '/mnt/metro',
      code: "    /opt/metroextractor-scripts/coastlines.sh >/mnt/metro/logs/coastlines.log 2>&1\n"
    )
  end
end
