def create_gunicorn_config(config)
  ChefSpec::Matchers::ResourceMatcher.new(:gunicorn_config, :create, config)
end
