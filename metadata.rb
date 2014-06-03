name             'metroextractor'
maintainer       'mapzen'
maintainer_email 'grant@mapzen.com'
license          'GPL v3'
description      'Installs/Configures extractor'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.2'

recipe 'metroextractor', 'Builds metro extracts'

%w(
  apt
  osm2pgsql
  osmosis
  postgresql
  user
).each do |dep|
  depends dep
end

%w(ubuntu).each do |os|
  supports os
end
