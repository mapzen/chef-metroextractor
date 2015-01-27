require 'spec_helper'

describe 'metroextractor::user' do
  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" postgres | grep osm").and_return(true)
  end

  context 'requested user account is something other than root' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.automatic[:memory][:total] = '2048kB'
      end.converge(described_recipe)
    end

    it 'should create the user metro' do
      expect(chef_run).to create_user_account('metro').with(
        manage_home:  false,
        home:         '/mnt/metro',
        shell:        '/bin/bash',
        ssh_keygen:   false,
        create_group: true,
        uid:          nil,
        git:          nil
      )
    end
  end

  context 'requested user account is root' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.automatic[:memory][:total]       = '2048kB'
        node.set[:metroextractor][:user][:id] = 'root'
      end.converge(described_recipe)
    end

    it 'should not create the user root' do
      expect(chef_run).to_not create_user_account('root')
    end
  end
end
