@odi @user
Feature: Create a project-specific user

  In order to operate the queuing system
  As a DevOps person
  I want to have a 'resque' user

  Background:
    * I have a server called "odi"
    * "odi" is running "ubuntu" "precise"
    * "odi" should be persistent
    * "odi" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag | databag_path |
      | users   | ./data_bags/users |

    * the "chef-client::service" recipe has been added to the "odi" run list
    * the "odi-users" recipe has been added to the "odi" run list
    * the chef-client has been run on "odi"

    * I ssh to "odi" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "odi" in the output

  Scenario: User 'resque' exists
    * I run "sudo resque"
    * I should not see "Unknown id" in the output

  Scenario: User's shell should be bash
    * I run "su - resque -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output
