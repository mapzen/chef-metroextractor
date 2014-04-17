require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start!

# load custom matchers
Dir.glob('spec/support/matchers/*.rb') do |custom_matcher|
  load "#{custom_matcher}"
end

RSpec.configure do |config|
  config.log_level  = :error
  config.platform   = 'ubuntu'
  config.version    = '12.04'
end
