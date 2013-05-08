@superawesomeserver
Feature: Perform test driven infrastructure with Cucumber-Chef
  In order to learn how to develop test driven infrastructure
  As an infrastructure developer
  I want to better understand how to use Cucumber-Chef

  Background:
     * I ssh to "superawesomeserver" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |
     * I run "echo 'prawn' > /tmp/prawn"

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "superawesomeserver" in the output

  Scenario: Default root shell is bash
    When I run "echo $SHELL"
    Then I should see "bash" in the output

  Scenario: Default gateway and resolver are using Cucumber-Chef Test Lab
    When I run "route -n | grep 'UG'"
    Then I should see "192.168.255.254" in the output

    When I run "cat /etc/resolv.conf"
    Then I should see "192.168.255.254" in the output
    And I should see "8.8.8.8" in the output
    And I should see "8.8.4.4" in the output

  Scenario: postfix is installed
    * I run "chef-client"
    * package "postfix" should be installed

