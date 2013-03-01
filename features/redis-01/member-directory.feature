@redis-01 @deploy
Feature: Deploy member directory code

  In order to run our application
  As a DevOps person
  I want to have the latest good code deployed

  Background:
    * I have a server called "redis-01"
    * "redis-01" is running "ubuntu" "precise"
    * "redis-01" should be persistent
    * "redis-01" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag          | databag_path                 |
      | member-directory | ./data_bags/member-directory |

    * the "chef-client::service" recipe has been added to the "redis-01" run list
    * the "odi-deployment" recipe has been added to the "redis-01" run list
    * the chef-client has been run on "redis-01"

    * I ssh to "redis-01" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "redis-01" in the output

  Scenario: User 'members' exists
    * I run "sudo members"
    * I should not see "Unknown id" in the output

  Scenario: User's shell should be bash
    * I run "su - members -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output

  Scenario: User can sudo with no password
  # we cannot test this properly on Vagrant!
    * I run "su - members -c 'sudo bash'"
    * I should not see "password for members" in the output

  Scenario: Ruby 1.9.3 is installed
    * I run "su - members -c 'ruby -v'"
    * I should see "1.9.3" in the output

  Scenario: code is deployed
    * directory "/var/www/members.theodi.org" should exist
    * directory "/var/www/members.theodi.org/releases" should exist
    * directory "/var/www/members.theodi.org/shared" should exist
