#
# Cookbook Name:: metroextractor
# Recipe:: default
#

%w(
  apt::default
  metroextractor::postgres
  metroextractor::user
  metroextractor::setup
  metroextractor::planet
  metroextractor::extracts
  metroextractor::shapes
  metroextractor::coastlines
).each do |r|
  include_recipe r
end
