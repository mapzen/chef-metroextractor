name             'metroextractor'
maintainer       'mapzen'
maintainer_email 'grant@mapzen.com'
license          'GPL v3'
description      'Installs/Configures extractor'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url       'https://github.com/mapzen/chef-metroextractor/issues'
source_url       'https://github.com/mapzen/chef-metroextractor'
version          '1.0.0'

recipe 'metroextractor', 'Builds metro extracts'

%w(
  apt
  ark
  osm2pgsql
  postgresql
  python
  user
).each do |dep|
  depends dep
end

%w(ubuntu).each do |os|
  supports os
end
