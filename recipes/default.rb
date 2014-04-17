#
# Cookbook Name:: metroextractor
# Recipe:: default
#

%w(
  apt
  metroextractor::postgres
  metroextractor::setup
  metroextractor::planet
  metroextractor::extracts
  metroextractor::shapes
).each do |r|
  include_recipe r
end
