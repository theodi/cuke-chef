@redis-01 @user
Feature: Create a project-specific user

  In order to operate the queuing system
  As a DevOps person
  I want to have a 'resque' user

  Background:
    * I have a server called "redis-01"
    * "redis-01" is running "ubuntu" "precise"
    * "redis-01" should be persistent
    * "redis-01" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag | databag_path |
      | users   | ./data_bags/users |

    * the "chef-client::service" recipe has been added to the "redis-01" run list
    * the "odi-users" recipe has been added to the "redis-01" run list
    * the chef-client has been run on "redis-01"

    * I ssh to "redis-01" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "redis-01" in the output

  Scenario: User 'resque' exists
    * I run "sudo resque"
    * I should not see "Unknown id" in the output

  Scenario: User's shell should be bash
    * I run "su - resque -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output
