@services-manager
Feature: Build a fully-operational battlestation^W services-manager.theodi.org node from scratch

  In order to run the office services-manager
  As the ODI
  I want to install and configure many things

  Background:
    * I have a server called "services-manager"
    * "services-manager" is running "ubuntu" "precise"
    * "services-manager" should be persistent

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role         | role_path |
      | *.rb         | ./roles/  |

    * the following databags have been updated:
      | databag          | databag_path                 |
      | envs             | ./data_bags/envs             |
      | certs            | ./data_bags/certs            |

    * "services-manager" is in the "cucumber" environment
    * "services-manager" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::cron" recipe has been added to the "services-manager" run list
    * the "services-manager" role has been added to the "services-manager" run list
    * the chef-client has been run on "services-manager"

    * I ssh to "services-manager" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "services-manager" in the output

  Scenario: Core dependencies are installed
    * package "build-essential" should be installed
    * package "git" should be installed
    * package "curl" should be installed

  Scenario: User 'services-manager' exists
    * I run "su - services-manager -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output

  Scenario: User can sudo with no password
  # we cannot test this properly on Vagrant!
  #  * I run "su - services-manager -c 'sudo bash'"
  #  * I should not see "password for services-manager" in the output
  # So we compromise with this
    * file "/etc/sudoers.d/services-manager" should exist
    * file "/etc/sudoers.d/services-manager" should contain
    """
services-manager ALL=NOPASSWD:ALL
    """
    * file "/etc/sudoers" should contain
    """
#includedir /etc/sudoers.d
    """
    * I run "stat -c %a /etc/sudoers.d/services-manager"
    * I should see "440" in the output

  Scenario: Ruby 1.9.3-p374 is installed
    * I run "su - services-manager -c 'ruby -v'"
    * I should see "1.9.3p374" in the output

  Scenario: Gem dependencies are installed
    * package "libxml2-dev" should be installed
    * package "libxslt1-dev" should be installed
    * package "libcurl4-openssl-dev" should be installed

  Scenario: nginx is installed
    * package "nginx" should be installed

  Scenario: Code is deployed
    * directory "/var/www/services-manager.theodi.org" should exist
    * directory "/var/www/services-manager.theodi.org/releases" should exist
    * directory "/var/www/services-manager.theodi.org/shared" should exist
    * directory "/var/www/services-manager.theodi.org/shared/config" should exist

  @env
  Scenario: The env file exists
    * file "/var/www/services-manager.theodi.org/shared/config/env" should exist
  @env
  Scenario: The env file contains the correct stuff
    When I run "cat /var/www/services-manager.theodi.org/shared/config/env"
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
    And I should see "COURSES_RSYNC_PATH: json" in the output
  @env
  Scenario: configuration stuff is correct
    * symlink "/var/www/services-manager.theodi.org/current/.env" should exist
    When I run "stat -c %N /var/www/services-manager.theodi.org/current/.env"
    Then I should see "../../shared/config/env" in the output

  @startup
  Scenario: Startup scripts are in play
    * file "/etc/init/services-manager.conf" should exist
    * file "/etc/init/services-manager-scheduler.conf" should exist
    * file "/etc/init/services-manager-worker.conf" should exist
    When I run "cat /etc/init/services-manager-worker-1.conf"
    Then I should see "exec su - services-manager" in the output
    And I should see "export PORT=3000" in the output
    And I should see "/var/log/services-manager/worker-1.log" in the output

@nginx
  Scenario: nginx virtualhosts are correct
    * symlink "/etc/nginx/sites-enabled/default" should not exist
    * file "/etc/nginx/sites-available/services-manager.theodi.org" should exist

@nginx @vhost
  Scenario: virtualhost should contain correct stuff
    * file "/etc/nginx/sites-available/services-manager.theodi.org" should contain
    """
upstream services-manager {
  server 127.0.0.1:3000;
}

server {
  listen 80 default;
  server_name services-manager.theodi.org;
  access_log /var/log/nginx/services-manager.theodi.org.log;
  error_log /var/log/nginx/services-manager.theodi.org.err;
  location / {
    try_files $uri @backend;
  }

location @backend {
  proxy_set_header X-Forwarded-Proto 'http';
  proxy_set_header Host $server_name;
  proxy_pass http://services-manager;
  }
}
    """

  @nginx
  Scenario: virtualhost should be symlinked
    * symlink "/etc/nginx/sites-enabled/services-manager.theodi.org" should exist

  Scenario: nginx should be restarted
## we can't really test this

  @xero
  Scenario: xero cert exists
    * file "/etc/certs/xero/privatekey.pem" should exist
    When I run "cat /etc/certs/xero/privatekey.pem"
    Then I should see "V8lu0NcIVwuH" in the output
