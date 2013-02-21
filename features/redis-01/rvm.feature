@redis-01 @rvm
Feature: Install and configure rvm

  In order to use a sensible Ruby
  As a DevOps person
  I want to have RVM installed and configured

  Background:
    * I have a server called "redis-01"
    * "redis-01" is running "ubuntu" "precise"
    * "redis-01" should be persistent
    * "redis-01" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::service" recipe has been added to the "redis-01" run list
    * the "odi-rvm" recipe has been added to the "redis-01" run list
    * the chef-client has been run on "redis-01"

    * I ssh to "redis-01" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "redis-01" in the output

  Scenario: Ruby 1.9.3 is installed
    * I run "su - ubuntu -c 'ruby -v'"
    * I should see "1.9.3" in the output
