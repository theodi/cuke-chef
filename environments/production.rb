name 'production'

default_attributes 'ENV'      => 'production',
                   'RACK_ENV' => 'production'

cookbook 'apt', '= 1.9.0'
cookbook 'build-essential', '= 1.3.4'
cookbook 'git', '= 2.3.0'
cookbook 'odi-users', '= 0.1.0'
cookbook 'odi-rvm', '= 0.1.0'
cookbook 'odi-xml', '= 0.1.0'
cookbook 'xslt', '= 0.0.1'
cookbook 'libcurl', '= 0.1.0'
cookbook 'sqlite', '= 0.1.0'
cookbook 'redisio', '= 1.4.1'
cookbook 'odi-deployment', '= 0.1.0'
cookbook 'odi-nginx', '= 0.1.0'
cookbook 'envbuilder', '= 0.1.4'
