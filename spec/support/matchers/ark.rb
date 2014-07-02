def install_ark(ark)
  ChefSpec::Matchers::ResourceMatcher.new(:ark, :install, ark)
end
