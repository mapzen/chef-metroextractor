#
# Cookbook Name:: metroextractor
# Recipe:: default
#

%w(
  apt
  metroextractor::postgres
  metroextractor::user
  metroextractor::setup
  metroextractor::planet
  metroextractor::extracts
).each do |r|
  include_recipe r
end
