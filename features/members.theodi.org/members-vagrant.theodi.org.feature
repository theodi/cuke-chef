@members-vagrant
Feature: Provision a fully-operational battlestation^W member.theodi.org node for dev

  In order to develop the membership system
  As the ODI
  I want to install and configure many things

  Background:
    * I have a server called "members-vagrant"
    * "members-vagrant" is running "ubuntu" "precise"
    * "members-vagrant" should be persistent

    * the following environment has been uploaded:
      | environment | environment_path |
      | vagrant.rb  | ./environments/  |

    * the following roles have been uploaded:
      | role       | role_path |
      | members.rb | ./roles/  |

    * "members-vagrant" is in the "vagrant" environment
    * "members-vagrant" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag          | databag_path                 |
      | member-directory | ./data_bags/member-directory |

    * the "chef-client::service" recipe has been added to the "members-vagrant" run list
    * the "members" role has been added to the "members-vagrant" run list
    * the chef-client has been run on "members-vagrant"

    * I ssh to "members-vagrant" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "members-vagrant" in the output

  Scenario: Core dependencies are installed
    * package "build-essential" should be installed
    * package "git" should be installed
    * package "curl" should be installed

  Scenario: User 'vagrant' exists
    * I run "su - vagrant -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output

  Scenario: Ruby 1.9.3-p374 is installed
    * I run "su - vagrant -c 'ruby -v'"
    * I should see "1.9.3p374" in the output

  Scenario: Gem dependencies are installed
    * package "libxml2-dev" should be installed
    * package "libxslt1-dev" should be installed
    * package "libcurl4-openssl-dev" should be installed
    * package "libsqlite3-dev" should be installed

  Scenario: Redis server is installed
    * I run "redis-server -h"
    * I should not see "command not found" in the output
    * service "redis" should be running

  Scenario: Code has *not* been deployed
    When I run "ls /var/www/members.theodi.org/"
    Then I should see "No such file or directory" in the output

