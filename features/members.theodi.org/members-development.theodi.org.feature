@members-development
Feature: Provision a fully-operational battlestation^W member.theodi.org node for dev

  In order to develop the membership system
  As the ODI
  I want to install and configure many things

  Background:
    * I have a server called "members-development"
    * "members-development" is running "ubuntu" "precise"
    * "members-development" should be persistent
    * "members-development" is in the "development" environment
    * "members-development" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following environment has been uploaded:
      | environment    | environment_path |
      | development.rb | ./environments/  |

    * the following databags have been updated:
      | databag          | databag_path                 |
      | member-directory | ./data_bags/member-directory |

    * the "chef-client::service" recipe has been added to the "members-development" run list
    * the "members.theodi.org" recipe has been added to the "members-development" run list
    * the chef-client has been run on "members-development"

    * I ssh to "members-development" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "members-development" in the output

  Scenario: Core dependencies are installed
    * package "build-essential" should be installed
    * package "git" should be installed
    * package "curl" should be installed

  Scenario: Ruby 1.9.3-p374 is installed
    * I run "su - vagrant -c 'ruby -v'"
    * I should see "1.9.3p374" in the output

  Scenario: Gem dependencies are installed
    * package "libxml2-dev" should be installed
    * package "libxslt1-dev" should be installed
    * package "libcurl4-openssl-dev" should be installed
    * package "libsqlite3-dev" should be installed