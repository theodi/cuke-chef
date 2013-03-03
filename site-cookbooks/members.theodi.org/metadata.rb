name             'members.theodi.org'
maintainer       'The Open Data Institute'
maintainer_email 'tech@theodi.org'
license          'MIT'
description      'Installs/Configures members.theodi.org'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt"
depends "git"
depends "xslt"
depends "odi-xml"
depends "libcurl"
depends "mysql"
depends "sqlite"
depends "nginx"
depends "redisio"
depends "nodejs"
depends "odi-users"
depends "odi-rvm"
depends "odi-deployment"