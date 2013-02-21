@www-theodi-org @mysql
Feature: mysql is installed and configured correctly
  In order to operate a Drupal website
  As a DevOps person
  I want to have mysql installed

  Background:
    Given I have a server called "www-theodi-org"
    And "www-theodi-org" is running "ubuntu" "precise"
    And "www-theodi-org" should be persistent
    And "www-theodi-org" has been provisioned

    And all of the cookbooks in "./cookbooks" have been uploaded
    And all of the cookbooks in "./site-cookbooks" have been uploaded

    And the "chef-client::service" recipe has been added to the "www-theodi-org" run list

    And the "mysql::server" recipe has been added to the "www-theodi-org" run list

    And the chef-client has been run on "www-theodi-org"

    When I ssh to "www-theodi-org" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "www-theodi-org" in the output

  Scenario: mysql-server is installed
    * package "mysql-server" should be installed
