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

  Scenario: nginx is installed
    * package "nginx" should be installed

  Scenario: Code is deployed
    * directory "/var/www/members.theodi.org" should exist
    * directory "/var/www/members.theodi.org/releases" should exist
    * directory "/var/www/members.theodi.org/shared" should exist
    * directory "/var/www/members.theodi.org/shared/config" should exist
    * directory "/var/www/members.theodi.org/shared/pid" should exist
    * directory "/var/www/members.theodi.org/shared/log" should exist
    * directory "/var/www/members.theodi.org/shared/system" should exist
    * symlink "/var/www/members.theodi.org/current/config/database.yml" should exist
    * file "/var/www/members.theodi.org/shared/config/database.yml" should be owned by "members:members"
    * symlink "/var/www/members.theodi.org/current/.env" should exist

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