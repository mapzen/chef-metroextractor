require 'spec_helper'

describe 'metroextractor::extracts' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  it 'should define the lockfile' do
    chef_run.should_not create_file '/mnt/metro/.osmosis.lock'
  end

  it 'should delete the lockfile if osmosis_force is set' do
    chef_run.node.set[:metroextractor][:extracts][:osmosis_force] = true
    chef_run.converge(described_recipe)

    chef_run.should delete_file '/mnt/metro/.osmosis.lock'
  end

  it 'should not delete the lockfile with defaults' do
    chef_run.node.set[:metroextractor][:extracts][:osmosis_force] = nil
    chef_run.converge(described_recipe)

    chef_run.should_not delete_file '/mnt/metro/.osmosis.lock'
  end

  it 'should run osmosis' do
    chef_run.should run_bash('osmosis').with(
      user:         'metro',
      cwd:          '/mnt/metro',
      environment:  { 'JAVACMD_OPTIONS' => '-server -XX:SurvivorRatio=8 -Xms1M -Xmx1M' },
      timeout:      345_600
    )
  end

end
