@members-production
Feature: Build a fully-operational battlestation^W member.theodi.org node from scratch

  In order to run the membership system
  As the ODI
  I want to install and configure many things

  Background:
    * I have a server called "members-production"
    * "members-production" is running "ubuntu" "precise"
    * "members-production" should be persistent

    * the following environment has been uploaded:
      | environment   | environment_path |
      | production.rb | ./environments/  |

    * the following roles have been uploaded:
      | role       | role_path |
      | members.rb | ./roles/  |

    * "members-production" is in the "production" environment
    * "members-production" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag          | databag_path                 |
      | member-directory | ./data_bags/member-directory |

    * the "chef-client::service" recipe has been added to the "members-production" run list
    * the "members" role has been added to the "members-production" run list
    * the chef-client has been run on "members-production"

    * I ssh to "members-production" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "members-production" in the output

  Scenario: Core dependencies are installed
    * package "build-essential" should be installed
    * package "git" should be installed
    * package "curl" should be installed

  Scenario: User 'members' exists
    * I run "su - members -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output

 Scenario: User can sudo with no password
  # we cannot test this properly on Vagrant!
  #  * I run "su - members -c 'sudo bash'"
  #  * I should not see "password for members" in the output
# So we compromise with this
    * file "/etc/sudoers.d/members" should exist
    * file "/etc/sudoers.d/members" should contain
    """
members ALL=NOPASSWD:ALL
    """
    * file "/etc/sudoers" should contain
    """
#includedir /etc/sudoers.d
    """
    * I run "stat -c %a /etc/sudoers.d/members"
    * I should see "440" in the output

  Scenario: Ruby 1.9.3-p374 is installed
    * I run "su - members -c 'ruby -v'"
    * I should see "1.9.3p374" in the output

  Scenario: Gem dependencies are installed
    * package "libxml2-dev" should be installed
    * package "libxslt1-dev" should be installed
    * package "libcurl4-openssl-dev" should be installed
    * package "libmysqlclient-dev" should be installed
    When I run "node -h"
    Then I should not see "command not found" in the output
    * package "imagemagick" should be installed

  Scenario: nginx is installed
    * package "nginx" should be installed

  Scenario: The env file exists
    * file "/var/www/members.theodi.org/shared/config/env" should exist

  Scenario: The env file contains the correct stuff
    When I run "cat /var/www/members.theodi.org/shared/config/env"
    Then I should see "JENKINS_URL: http://jenkins.theodi.org" in the output
    And I should see "RESQUE_REDIS_HOST: 151" in the output
    And I should see "EVENTBRITE_API_KEY: IZ" in the output
    And I should see "CAPSULECRM_DEFAULT_OWNER: ri" in the output
    And I should see "LEFTRONIC_GITHUB_OUTGOING_PRS: d" in the output
    And I should see "COURSES_TARGET_URL: http:" in the output
    And I should see "TRELLO_DEV_KEY: a1" in the output
    And I should see "GITHUB_OUATH_TOKEN: 18" in the output
    And I should see "GOOGLE_ANALYTICS_TRACKER: UA-3" in the output
    And I should see "XERO_PRIVATE_KEY_PATH: /etc" in the output

    @config
  Scenario: configuration stuff is correct
    * symlink "/var/www/members.theodi.org/current/config/database.yml" should exist
    * file "/var/www/members.theodi.org/shared/config/database.yml" should be owned by "members:members"
    * symlink "/var/www/members.theodi.org/current/.env" should exist
    When I run "stat -c %N /var/www/members.theodi.org/current/.env"
    Then I should see "/var/www/members.theodi.org/shared/config/env" in the output
    When I run "cat /var/www/members.theodi.org/shared/config/database.yml"
    Then I should see "production:" in the output
    And I should see "adapter: mysql2" in the output
    And I should see "port: 3306" in the output

      @deploy
  Scenario: Code is deployed
    * directory "/var/www/members.theodi.org" should exist
    * directory "/var/www/members.theodi.org/releases" should exist
    * directory "/var/www/members.theodi.org/shared" should exist
    * directory "/var/www/members.theodi.org/shared/config" should exist
    * directory "/var/www/members.theodi.org/shared/pid" should exist
    * directory "/var/www/members.theodi.org/shared/log" should exist
    * directory "/var/www/members.theodi.org/shared/system" should exist

  Scenario: Migrations have happened
    # there's no easy way to test for this

  Scenario: Assets have been compiled
    * directory "/var/www/members.theodi.org/current/public/assets/" should exist

@upstart
  Scenario: Startup scripts are in play
    * file "/etc/init/member-directory.conf" should exist
    * file "/etc/init/member-directory-thin.conf" should exist
    * file "/etc/init/member-directory-thin-1.conf" should exist
    When I run "cat /etc/init/member-directory-thin-1.conf"
    Then I should see "exec su - members" in the output
    And I should see "export PORT=3000" in the output
#    And I should see "RACK_ENV=production" in the output
    And I should see "/var/log/member-directory/thin-1.log" in the output

  Scenario: nginx virtualhost exists
    * file "/etc/nginx/sites-available/members.theodi.org" should exist

  Scenario: virtualhost should contain correct stuff
    * file "/etc/nginx/sites-available/members.theodi.org" should contain
    """
upstream member-directory {
  server 127.0.0.1:3000;
}

server {
  listen 80;
  server_name members.theodi.org;
  access_log /var/log/nginx/members.theodi.org.log;
  error_log /var/log/nginx/members.theodi.org.err;
  location / {
    try_files $uri @backend;
  }

  location ~ ^/(assets)/  {
    root /var/www/members.theodi.org/current/public/;
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  location @backend {
    proxy_set_header X-Forwarded-Proto 'http';
    proxy_set_header Host $server_name;
    proxy_pass http://member-directory;
  }
}
    """

  Scenario: virtualhost should be symlinked
    * symlink "/etc/nginx/sites-enabled/members.theodi.org" should exist


  Scenario: nginx should be restarted
    # we can't really test this