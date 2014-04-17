def create_user_account(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:user_account, :create, resource_name)
end

def delete_user_account(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:user_account, :delete, resource_name)
end
