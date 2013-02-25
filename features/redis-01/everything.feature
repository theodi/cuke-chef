@queue-master
Feature: Install and configure all the things

  In order to operate a queuing system
  As a DevOps person
  I want to have a bunch of things installed

  Background:
    * I have a server called "queue-master"
    * "queue-master" is running "ubuntu" "precise"
    * "queue-master" should be persistent
    * "queue-master" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::service" recipe has been added to the "queue-master" run list
    * the "odi-queue-master" recipe has been added to the "queue-master" run list
    * the chef-client has been run on "queue-master"

    * I ssh to "queue-master" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "queue-master" in the output

  Scenario: libxml2-dev is installed
    * package "libxml2-dev" should be installed

  Scenario: libxslt1-dev is installed
    * package "libxslt1-dev" should be installed

  Scenario: nginx is installed
    * package "nginx" should be installed

  Scenario: Redis is installed
    * package "redis-server" should be installed

  Scenario: Redis is running
    * service "redis" should be running

  Scenario: User 'resque' exists
    * I run "sudo resque"
    * I should not see "Unknown id" in the output

  Scenario: User's shell should be bash
    * I run "su - resque -c 'echo ${SHELL}'"
    * I should see "/bin/bash" in the output

  Scenario: Ruby 1.9.3 is installed
    * I run "su - resque -c 'ruby -v'"
    * I should see "1.9.3" in the output
