@dashboards
Feature: Build a fully-operational battlestation^W dashboards.theodi.org node from scratch

  In order to run the office dashboards
  As the ODI
  I want to install and configure many things

  Background:
    * I have a server called "dashboards"
    * "dashboards" is running "ubuntu" "precise"
    * "dashboards" should be persistent

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role         | role_path |
      | *.rb         | ./roles/  |

    * "dashboards" is in the "cucumber" environment
    * "dashboards" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::cron" recipe has been added to the "dashboards" run list
    * the "dashboards" role has been added to the "dashboards" run list
    * the chef-client has been run on "dashboards"

    * I ssh to "dashboards" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "dashboards" in the output

  Scenario: Core dependencies are installed
    * package "build-essential" should be installed
    * package "git" should be installed
    * package "curl" should be installed

  Scenario: User 'dashboards' exists
    * I run "su - dashboards -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output

  Scenario: User can sudo with no password
  # we cannot test this properly on Vagrant!
  #  * I run "su - dashboards -c 'sudo bash'"
  #  * I should not see "password for dashboards" in the output
  # So we compromise with this
    * file "/etc/sudoers.d/dashboards" should exist
    * file "/etc/sudoers.d/dashboards" should contain
    """
dashboards ALL=NOPASSWD:ALL
    """
    * file "/etc/sudoers" should contain
    """
#includedir /etc/sudoers.d
    """
    * I run "stat -c %a /etc/sudoers.d/dashboards"
    * I should see "440" in the output

  Scenario: Ruby 1.9.3-p374 is installed
    * I run "su - dashboards -c 'ruby -v'"
    * I should see "1.9.3p374" in the output

  Scenario: Gem dependencies are installed
    * package "libxml2-dev" should be installed
    * package "libxslt1-dev" should be installed
    * package "libcurl4-openssl-dev" should be installed
    When I run "node -h"
    Then I should not see "command not found" in the output

  Scenario: nginx is installed
    * package "nginx" should be installed

  Scenario: Code is deployed
    * directory "/var/www/dashboards.theodi.org" should exist
    * directory "/var/www/dashboards.theodi.org/releases" should exist
    * directory "/var/www/dashboards.theodi.org/shared" should exist
    * directory "/var/www/dashboards.theodi.org/shared/config" should exist
    * directory "/var/www/dashboards.theodi.org/shared/pid" should exist
    * directory "/var/www/dashboards.theodi.org/shared/log" should exist
    * directory "/var/www/dashboards.theodi.org/shared/system" should exist

  @startup
  Scenario: Startup scripts are in play
    * file "/etc/init/dashboards.conf" should exist
    * file "/etc/init/dashboards-dashing.conf" should exist
    * file "/etc/init/dashboards-dashing-1.conf" should exist
    When I run "cat /etc/init/dashboards-dashing-1.conf"
    Then I should see "exec su - dashboards" in the output
    And I should see "export PORT=3000" in the output
    And I should see "/var/log/dashboards/dashing-1.log" in the output

@nginx
  Scenario: nginx virtualhosts are correct
    * symlink "/etc/nginx/sites-enabled/default" should not exist
    * file "/etc/nginx/sites-available/dashboards.theodi.org" should exist

@nginx
  Scenario: virtualhost should contain correct stuff
    * file "/etc/nginx/sites-available/dashboards.theodi.org" should contain
    """
upstream dashboards {
  server 127.0.0.1:3000;
}

server {
  listen 80 default;
  server_name dashboards.theodi.org;
  access_log /var/log/nginx/dashboards.theodi.org.log;
  error_log /var/log/nginx/dashboards.theodi.org.err;
  location / {
    try_files $uri @backend;
  }

  location ~ ^/(assets)/  {
    root /var/www/dashboards.theodi.org/current/public/;
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  location @backend {
    proxy_set_header X-Forwarded-Proto 'http';
    proxy_set_header Host $server_name;
    proxy_pass http://dashboards;
  }
}
    """

  Scenario: virtualhost should be symlinked
    * symlink "/etc/nginx/sites-enabled/dashboards.theodi.org" should exist

  Scenario: nginx should be restarted
# we can't really test this