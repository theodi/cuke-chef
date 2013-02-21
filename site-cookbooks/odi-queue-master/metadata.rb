name             'odi-queue-master'
maintainer       'The Open Data Institute'
maintainer_email 'tech@theodi.org'
license          'MIT'
description      'Installs/Configures odi-queue-master'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "xslt"
depends "odi-xml"
depends "nginx"
depends "redis"
depends "odi-rvm"
