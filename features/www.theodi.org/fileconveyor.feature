@www-theodi-org @fileconveyor
Feature: Fileconveyor is installed and set up properly
  In order to do get user uploaded files added to Rackspace
  As a DevOps person
  I want to make sure fileconveyor is installed and set up properly

  Background:
    Given I have a server called "theodi-org"
    And "theodi-org" is running "ubuntu" "precise"
    And "theodi-org" should be persistent
    And "theodi-org" has been provisioned
    And "theodi-org" is in the "cucumber" environment

    And all of the cookbooks in "./cookbooks" have been uploaded
    And all of the cookbooks in "./site-cookbooks" have been uploaded

    And the following databags have been updated:
      | databag | databag_path        |
      | website | ./data_bags/website |

    And the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    And the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    And the "chef-client::service" recipe has been added to the "theodi-org" run list

    And the "odi-drupal" role has been added to the "theodi-org" run list
    
    And the chef-client has been run on "theodi-org"

    When I ssh to "theodi-org" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "theodi-org" in the output
  
  Scenario: Python should be installed
    When I run "python -V"
    Then I should see "Python 2.7" in the output
    
  Scenario: Fileconveyor should be installed with the correct settings
    * directory "/var/fileconveyor" should exist
    * file "/var/fileconveyor/fileconveyor/config.xml" should contain
    """
<source name="drupal" scanPath="/var/www/theodi.org" documentRoot="/var/www/theodi.org" basePath="/" />
    """
   * file "/var/fileconveyor/fileconveyor/config.xml" should contain
   """
<!-- Rules -->
<rules>
<rule for="drupal" label="Images" fileDeletionDelayAfterSync="60000000000000000">
  <filter>
    <paths>sites/default/files</paths>
    <extensions>ico:gif:png:jpg:jpeg:svg:swf</extensions>
  </filter>
  <processorChain>
  </processorChain>
  <destinations>
    <destination server="rackspace" path="" />
  </destinations>
</rule>
</rules>
    """
    * file "/var/fileconveyor/fileconveyor/settings.py" should contain
    """
PERSISTENT_DATA_DB = './persistent_data.db'
SYNCED_FILES_DB = './synced_files.db'
    """

  Scenario: Fileconveyor dependencies should be installed
    * path "/usr/local/lib/python2.7/dist-packages/django_cumulus-.*.egg" should exist
    * path "/usr/local/lib/python2.7/dist-packages/Django-.*.egg" should exist
    * path "/usr/local/lib/python2.7/dist-packages/python_cloudfiles-.*.egg" should exist
    * path "/usr/local/lib/python2.7/dist-packages/boto-.*.egg" should exist
    * path "/usr/local/lib/python2.7/dist-packages/cssutils-.*.egg" should exist
  
  @background-task  
  Scenario: Fileconveyor should be running
    When I run "ps aux | grep arbitrator.py"
    Then the exit code should be "0"
    And I should see "python arbitrator.py" in the output 
    
  Scenario: Drupal CDN should be set up properly
    When I run "drush vget | grep cdn"
    Then I should see "cdn_advanced_pid_file: \"/var/fileconveyor/fileconveyor/fileconveyor.pid\"" in the output
    And I should see "cdn_advanced_synced_files_db: \"/var/fileconveyor/fileconveyor/synced_files.db\"" in the output
    And I should see "cdn_mode: \"advanced\"" in the output
    And I should see "cdn_status: \"2\""