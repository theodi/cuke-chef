@calendar
Feature: Build a fully-operational battlestation^W calendar.theodi.org node from scratch

  In order to run the office calendar
  As the ODI
  I want to install and configure many things

  Background:
    * I have a server called "calendar"
    * "calendar" is running "ubuntu" "precise"
    * "calendar" should be persistent

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role         | role_path |
      | *.rb  | ./roles/  |

    * "calendar" is in the "cucumber" environment
    * "calendar" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag          | databag_path                 |
      | envs             | ./data_bags/envs             |
      | office-calendar  | ./data_bags/office-calendar  |

    * the "chef-client::cron" recipe has been added to the "calendar" run list
    * the "calendar" role has been added to the "calendar" run list
    * the chef-client has been run on "calendar"

    * I ssh to "calendar" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "calendar" in the output

  Scenario: Core dependencies are installed
    * package "build-essential" should be installed
    * package "git" should be installed
    * package "curl" should be installed

  Scenario: User 'calendar' exists
    * I run "su - calendar -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output

  Scenario: User can sudo with no password
  # we cannot test this properly on Vagrant!
  #  * I run "su - calendar -c 'sudo bash'"
  #  * I should not see "password for calendar" in the output
  # So we compromise with this
    * file "/etc/sudoers.d/calendar" should exist
    * file "/etc/sudoers.d/calendar" should contain
    """
calendar ALL=NOPASSWD:ALL
    """
    * file "/etc/sudoers" should contain
    """
#includedir /etc/sudoers.d
    """
    * I run "stat -c %a /etc/sudoers.d/calendar"
    * I should see "440" in the output

  Scenario: Ruby 1.9.3-p374 is installed
    * I run "su - calendar -c 'ruby -v'"
    * I should see "1.9.3p374" in the output

  Scenario: Gem dependencies are installed
    * package "libxml2-dev" should be installed
    * package "libxslt1-dev" should be installed
    * package "libcurl4-openssl-dev" should be installed
    * package "libmysqlclient-dev" should be installed
    When I run "node -h"
    Then I should not see "command not found" in the output

  Scenario: nginx is installed
    * package "nginx" should be installed

@envfile
  Scenario: The env file exists
    * file "/var/www/calendar.theodi.org/shared/config/env" should exist

  Scenario: The env file contains the correct stuff
    When I run "cat /var/www/calendar.theodi.org/shared/config/env"
    Then I should see "GAPPS_DOMAIN_NAME: theodi.org" in the output
    And I should see "GAPPS_USER_EMAIL: system" in the output
    And I should see "GAPPS_PASSWORD: R8T" in the output
    And I should see "GAPPS_SERVICE_ACCOUNT_EMAIL: 8161" in the output
    And I should see "GAPPS_PRIVATE_KEY_PATH: /etc/certs/google/pr" in the output
    And I should see "RESQUE_REDIS_HOST: 151" in the output
    And I should see "RESQUE_REDIS_PASSWORD: W"
  
  @certificate  
  Scenario: The Google apps certificate file is uploaded
    * file "/etc/certs/google/privatekey.p12" should exist
    When I run "md5sum /etc/certs/google/privatekey.p12"
    Then I should see "96b3e4" in the output

  Scenario: Code is deployed
    * directory "/var/www/calendar.theodi.org" should exist
    * directory "/var/www/calendar.theodi.org/releases" should exist
    * directory "/var/www/calendar.theodi.org/shared" should exist
    * directory "/var/www/calendar.theodi.org/shared/config" should exist
    * directory "/var/www/calendar.theodi.org/shared/pid" should exist
    * directory "/var/www/calendar.theodi.org/shared/log" should exist
    * directory "/var/www/calendar.theodi.org/shared/system" should exist

  @configurationstuff
  Scenario: configuration stuff is correct
    * file "/var/www/calendar.theodi.org/current/config/database.yml" should exist
    * file "/var/www/calendar.theodi.org/current/config/database.yml" should be owned by "calendar:calendar"
    * symlink "/var/www/calendar.theodi.org/current/.env" should exist
    When I run "stat -c %N /var/www/calendar.theodi.org/current/.env"
    Then I should see "../../shared/config/env" in the output
    When I run "cat /var/www/calendar.theodi.org/current/config/database.yml"
    Then I should see "production:" in the output
    And I should see "adapter: mysql2" in the output
    And I should see "port: 3306" in the output

  Scenario: Assets have been compiled
    * directory "/var/www/calendar.theodi.org/current/public/assets/" should exist

  @startup
  Scenario: Startup scripts are in play
    * file "/etc/init/office-calendar.conf" should exist
    * file "/etc/init/office-calendar-thin.conf" should exist
    * file "/etc/init/office-calendar-thin-1.conf" should exist
    When I run "cat /etc/init/office-calendar-thin-1.conf"
    Then I should see "exec su - calendar" in the output
    And I should see "export PORT=3000" in the output
#    And I should see "RACK_ENV=production" in the output
    And I should see "/var/log/office-calendar/thin-1.log" in the output

@nginx
  Scenario: nginx virtualhosts are correct
    * symlink "/etc/nginx/sites-enabled/default" should not exist
    * file "/etc/nginx/sites-available/calendar.theodi.org" should exist

@nginx
  Scenario: virtualhost should contain correct stuff
    * file "/etc/nginx/sites-available/calendar.theodi.org" should contain
    """
upstream office-calendar {
  server 127.0.0.1:3000;
}

server {
  listen 80 default;
  server_name calendar.theodi.org;
  access_log /var/log/nginx/calendar.theodi.org.log;
  error_log /var/log/nginx/calendar.theodi.org.err;
  location / {
    try_files $uri @backend;
  }

  location ~ ^/(assets)/  {
    root /var/www/calendar.theodi.org/current/public/;
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  location @backend {
    proxy_set_header X-Forwarded-Proto 'http';
    proxy_set_header Host $server_name;
    proxy_pass http://office-calendar;
  }
}
    """

  Scenario: virtualhost should be symlinked
    * symlink "/etc/nginx/sites-enabled/calendar.theodi.org" should exist

  Scenario: nginx should be restarted
# we can't really test this