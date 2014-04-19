require 'spec_helper'

describe 'metroextractor::user' do

  context 'requested user account is something other than root' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.automatic[:memory][:total] = '2048kB'
      end.converge(described_recipe)
    end

    it 'should create the user metro' do
      chef_run.should create_user_account('metro').with(
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
      chef_run.should_not create_user_account('root')
    end
  end

end
