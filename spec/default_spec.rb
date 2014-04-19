require 'spec_helper'

describe 'metroextractor::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  %w(
    apt
    metroextractor::user
    metroextractor::setup
    metroextractor::planet
    metroextractor::extracts
  ).each do |r|
    it "should include the #{r} recipe" do
      chef_run.should include_recipe r
    end
  end
end
