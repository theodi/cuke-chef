@pkcookbook
Feature: Put the ODI tech team's public keys onto nodes

  Background:
    * I have a server called "pk-test"
    * "pk-test" is running "ubuntu" "precise"
    * "pk-test" should be persistent

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * "pk-test" is in the "cucumber" environment
    * "pk-test" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::service" recipe has been added to the "pk-test" run list
    * the "git" recipe has been added to the "pk-test" run list
    * the "odi-pk" recipe has been added to the "pk-test" run list
    * the chef-client has been run on "pk-test"

    * I ssh to "pk-test" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "pk-test" in the output

  Scenario: User "odi" exists
    When I run "su - odi -c 'echo ${SHELL}'"
    Then I should see "/bin/bash" in the output
    And directory "/home/odi/" should exist

  Scenario: User can sudo with no password
  # we cannot test this properly on Vagrant!
  #  * I run "su - odi -c 'sudo bash'"
  #  * I should not see "password for odi" in the output
  # So we compromise with this
    * file "/etc/sudoers.d/odi" should exist
    * file "/etc/sudoers.d/odi" should contain
    """
odi ALL=NOPASSWD:ALL
    """
    * file "/etc/sudoers" should contain
    """
#includedir /etc/sudoers.d
    """
    * I run "stat -c %a /etc/sudoers.d/odi"
    * I should see "440" in the output

    @authkeys
  Scenario: authorized_keys is correct
    When I run "cat /home/odi/.ssh/authorized_keys"
    Then I should see "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvMnnXQFi7\+ag6kv7LhP0prMLsfUcsfwb" in the output
    And I should see "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTN0zh8RnXS7lEoBToiccK9NsKve" in the output
    And file "/home/odi/.ssh/authorized_keys" should be owned by "odi:odi"
