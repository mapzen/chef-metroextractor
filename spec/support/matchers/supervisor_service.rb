def enable_supervisor_service(service)
  ChefSpec::Matchers::ResourceMatcher.new(:supervisor_service, :enable, service)
end

def start_supervisor_service(service)
  ChefSpec::Matchers::ResourceMatcher.new(:supervisor_service, :start, service)
end
