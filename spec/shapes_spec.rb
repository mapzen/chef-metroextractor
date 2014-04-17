require 'spec_helper'

describe 'metroextractor::shapes' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
  end

  %w(
    processed_p
    processed_i
    coastline_p
    coastline_i
    post_errors
    post_missing
  ).each do |dir|
    it "should run_bash ogr2ogr merc #{dir}" do
      chef_run.should run_bash("ogr2ogr merc #{dir}").with(
        cwd:  '/mnt',
        user: 'postgres'
      )
    end

    it "should run_bash tar merc #{dir}" do
      chef_run.should run_bash("tar merc #{dir}").with(
        cwd:  '/mnt',
        user: 'postgres'
      )
    end

    it "should run_bash ogr2ogr wgs84 #{dir}" do
      chef_run.should run_bash("ogr2ogr wgs84 #{dir}").with(
        cwd:  '/mnt',
        user: 'postgres'
      )
    end

    it "should run_bash tar wgs84 #{dir}" do
      chef_run.should run_bash("tar wgs84 #{dir}").with(
        cwd:  '/mnt',
        user: 'postgres'
      )
    end
  end

end
