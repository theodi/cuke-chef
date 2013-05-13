@squirrel
Feature: Build a functioning MySQL server

  In order to run database stuff
  As the ODI
  I want to install and configure MySQL

  Background:
    * I have a server called "squirrel"
    * "squirrel" is running "ubuntu" "precise"
    * "squirrel" should be persistent

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    * the following databags have been updated:
      | databag   | databag_path          |
      | databases | ./data_bags/databases |

    * "squirrel" is in the "cucumber" environment
    * "squirrel" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::cron" recipe has been added to the "squirrel" run list
    * the "squirrel" role has been added to the "squirrel" run list
    * the chef-client has been run on "squirrel"

    * I ssh to "squirrel" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "squirrel" in the output

  Scenario: MySQL is installed
    * package "mysql-server" should be installed

  Scenario: Can connect to database server
    When I run "mysql -ppasswordallthethings -e 'show databases'"
    Then I should not see "ERROR" in the output

  @restore
  Scenario: Database "theodi_org" exists
    When I run "mysql -ppasswordallthethings -e 'show databases'"
    Then I should see "theodi_org" in the output

  @user
  Scenario: hoppler user exists
    When I run "su - hoppler -c 'echo ${SHELL}'"
    Then I should see "/bin/bash" in the output

  @user
  Scenario: hoppler user has ruby 2
    When I run "su - hoppler -c 'ruby -v'"
    Then I should see "2.0.0" in the output

  @code
  Scenario: Hoppler is installed and cronned
    * path "/home/hoppler/hoppler" should exist
    * file "/home/hoppler/hoppler/lib/hoppler.rb" should exist
    * file "/etc/cron.d/hoppler" should contain
    """
    0 2 * * * hoppler cd /home/hoppler/hoppler && hoppler:backup
    0 3 * * 7 hoppler cd /home/hoppler/hoppler && hoppler:cleanup
    """

  @envfile
  Scenario: ~/.mysql.env is correct
    * file "/home/hoppler/hoppler/.mysql.env" should contain
    """
    MYSQL_USERNAME='root'
    MYSQL_PASSWORD='passwordallthethings'
    """
    * file "/home/hoppler/.env" should exist
