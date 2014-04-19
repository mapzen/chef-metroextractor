require 'spec_helper'

describe 'metroextractor::planet' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  it 'should download the planet' do
    chef_run.should create_remote_file('/mnt/metro/planet-latest.osm.pbf').with(
      source: 'http://ftp.heanet.ie/mirrors/openstreetmap.org/pbf/planet-latest.osm.pbf',
      mode:   0644
    )
  end

end
