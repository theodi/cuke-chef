@odi @rvm
Feature: Install and configure rvm

  In order to use a sensible Ruby
  As a DevOps person
  I want to have RVM installed and configured

  Background:
    * I have a server called "odi"
    * "odi" is running "ubuntu" "precise"
    * "odi" should be persistent
    * "odi" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::service" recipe has been added to the "odi" run list
    * the "odi-rvm" recipe has been added to the "odi" run list
    * the chef-client has been run on "odi"

    * I ssh to "odi" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "odi" in the output

  Scenario: Ruby 1.9.3 is installed
    * I run "su - resque -c 'ruby -v'"
    * I should see "1.9.3" in the output
