@members
Feature: Build a fully-operational battlestation^W member.theodi.org node from scratch

  In order to run the membership system
  As the ODI
  I want to install and configure many things

  Background:
    * I have a server called "members"
    * "members" is running "ubuntu" "precise"
    * "members" should be persistent
    * "members" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded
    * the following databags have been updated:
      | databag          | databag_path                 |
      | member-directory | ./data_bags/member-directory |

    * the "chef-client::service" recipe has been added to the "members" run list
    * the "members.theodi.org" recipe has been added to the "members" run list
    * the chef-client has been run on "members"

    * I ssh to "members" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "members" in the output

  Scenario: build-essential is installed
    * package "build-essential" should be installed

  Scenario: libmysqlclient-dev is installed
    * package "libmysqlclient-dev" should be installed

  Scenario: libxml2-dev is installed
    * package "libxml2-dev" should be installed

  Scenario: libxslt1-dev is installed
    * package "libxslt1-dev" should be installed

  Scenario: curl libraries should be installed
    * package "libcurl3" should be installed
    * package "libcurl3-gnutls" should be installed
    * package "libcurl4-openssl-dev" should be installed

  Scenario: git is installed
    * package "git" should be installed

  Scenario: nginx is installed
    * package "nginx" should be installed

  Scenario: nodejs is installed
    * I run "node -h"
    * I should not see "command not found" in the output

  Scenario: Redis is installed
    * I run "redis-server -h"
    * I should not see "command not found" in the output

  Scenario: Redis is running
    * service "redis" should be running

@sqlite
  Scenario: Sqlite dev is installed
    * package "libsqlite3-dev" should be installed

  Scenario: MySQL is installed
    * package "mysql-server" should be installed

  Scenario: User's shell should be bash
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

  Scenario: Ruby 1.9.3 is installed
    * I run "su - members -c 'ruby -v'"
    * I should see "1.9.3" in the output

@deploy
  Scenario: code is deployed
    * directory "/var/www/members.theodi.org" should exist
    * directory "/var/www/members.theodi.org/releases" should exist
    * directory "/var/www/members.theodi.org/shared" should exist
    * directory "/var/www/members.theodi.org/shared/config" should exist
    * directory "/var/www/members.theodi.org/shared/pid" should exist
    * directory "/var/www/members.theodi.org/shared/log" should exist
    * directory "/var/www/members.theodi.org/shared/system" should exist
    * symlink "/var/www/members.theodi.org/current/config/database.yml" should exist
    * file "/var/www/members.theodi.org/shared/config/database.yml" should be owned by "members:members"

