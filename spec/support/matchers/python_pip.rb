def install_python_pip(package)
  ChefSpec::Matchers::ResourceMatcher.new(:python_pip, :install, package)
end

def remove_python_pip(package)
  ChefSpec::Matchers::ResourceMatcher.new(:python_pip, :remove, package)
end
