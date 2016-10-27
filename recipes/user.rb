#
# Cookbook Name:: metroextractor
# Recipe:: user
#

# create user provided someone doesn't tell us to
#   run as root.
user_account node[:metroextractor][:user][:id] do
  home          node[:metroextractor][:setup][:basedir]
  shell         node[:metroextractor][:user][:shell]
  manage_home   node[:metroextractor][:user][:manage_home]
  create_group  node[:metroextractor][:user][:create_group]
  ssh_keygen    node[:metroextractor][:user][:ssh_keygen]
  not_if        { node[:metroextractor][:user][:id] == 'root' }
end
