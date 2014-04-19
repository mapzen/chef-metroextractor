require 'spec_helper'

describe 'metroextractor::setup' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  %w(
    osmosis::default
  ).each do |r|
    it "should include the #{r} recipe" do
      chef_run.should include_recipe r
    end
  end

  it 'should install gdal-bin' do
    chef_run.should install_package 'gdal-bin'
  end

  it 'should create the directory /opt/metroextractor-scripts' do
    chef_run.should create_directory '/opt/metroextractor-scripts'
  end

  it 'should create template /opt/metroextractor-scripts/osmosis.sh' do
    chef_run.should create_template('/opt/metroextractor-scripts/osmosis.sh').with(
      mode:   0755,
      source: 'osmosis.sh.erb'
    )
  end

  it 'should create /mnt/metro/ex' do
    chef_run.should create_directory '/mnt/metro/ex'
  end

  it 'should create /mnt/metro/logs' do
    chef_run.should create_directory '/mnt/metro/logs'
  end
end
