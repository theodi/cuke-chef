@www-theodi-org @php
Feature: php is installed and configured correctly
  In order to operate a Drupal website
  As a DevOps person
  I want to have php installed

  Background:
    Given I have a server called "www-theodi-org"
    And "www-theodi-org" is running "ubuntu" "precise"
    And "www-theodi-org" should be persistent
    And "www-theodi-org" has been provisioned

    And all of the cookbooks in "./cookbooks" have been uploaded
    And all of the cookbooks in "./site-cookbooks" have been uploaded

    And the "chef-client::service" recipe has been added to the "www-theodi-org" run list

    And the "php" recipe has been added to the "www-theodi-org" run list
    And the "php::module_mysql" recipe has been added to the "www-theodi-org" run list
    And the "php::module_gd" recipe has been added to the "www-theodi-org" run list
    And the "php::module_memcache" recipe has been added to the "www-theodi-org" run list

    And the chef-client has been run on "www-theodi-org"

    When I ssh to "www-theodi-org" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "www-theodi-org" in the output

  Scenario: php 5.3.10 is installed
    When I run "php -v"
    Then I should see "PHP 5.3.10" in the output

  Scenario: php-mysql is installed
    * package "php5-mysql" should be installed

  Scenario: php-gd is installed
    * package "php5-gd" should be installed

  Scenario: php-memcache is installed
    * package "php5-memcache" should be installed
