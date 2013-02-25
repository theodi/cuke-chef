name             'odi-queue-master'
maintainer       'The Open Data Institute'
maintainer_email 'tech@theodi.org'
license          'MIT'
description      'Installs/Configures odi-queue-master'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt"
depends "xslt"
depends "odi-xml"
depends "nginx"
depends "redisio"
depends "odi-users"
depends "odi-rvm"
