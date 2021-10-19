@api @files_trashbin-app-required @files_sharing-app-required @notToImplementOnOCIS
Feature: using trashbin together with sharing

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file with content "to delete" to "/textfile0.txt"

  @smokeTest
  Scenario Outline: deleting a received folder doesn't move it to trashbin
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/shared"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/shared_file.txt"
    And user "Alice" has shared folder "/shared" with user "Brian"
    And user "Brian" has moved folder "/shared" to "/renamed_shared"
    When user "Brian" deletes folder "/renamed_shared" using the WebDAV API
    Then as "Brian" the folder with original path "/renamed_shared" should not exist in the trashbin
    Examples:
      | dav-path |
      | old      |
      | new      |


  Scenario Outline: deleting a file in a received folder moves it to the trashbin of both users
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/shared"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/shared_file.txt"
    And user "Alice" has shared folder "/shared" with user "Brian"
    And user "Brian" has moved file "/shared" to "/renamed_shared"
    When user "Brian" deletes file "/renamed_shared/shared_file.txt" using the WebDAV API
    Then as "Brian" the file with original path "/renamed_shared/shared_file.txt" should exist in the trashbin
    And as "Alice" the file with original path "/shared/shared_file.txt" should exist in the trashbin
    Examples:
      | dav-path |
      | old      |
      | new      |


  Scenario Outline: sharee deleting a file in a group-shared folder moves it to the trashbin of sharee and sharer only
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has created folder "/shared"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/shared_file.txt"
    And user "Alice" has shared folder "/shared" with group "grp1"
    When user "Brian" deletes file "/shared/shared_file.txt" using the WebDAV API
    Then as "Brian" the file with original path "/shared/shared_file.txt" should exist in the trashbin
    And as "Alice" the file with original path "/shared/shared_file.txt" should exist in the trashbin
    And as "Carol" the file with original path "/shared/shared_file.txt" should not exist in the trashbin
    Examples:
      | dav-path |
      | old      |
      | new      |


  Scenario Outline: sharer deleting a file in a group-shared folder moves it to the trashbin of sharer only
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has created folder "/shared"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/shared_file.txt"
    And user "Alice" has shared folder "/shared" with group "grp1"
    When user "Alice" deletes file "/shared/shared_file.txt" using the WebDAV API
    Then as "Alice" the file with original path "/shared/shared_file.txt" should exist in the trashbin
    And as "Brian" the file with original path "/shared/shared_file.txt" should not exist in the trashbin
    And as "Carol" the file with original path "/shared/shared_file.txt" should not exist in the trashbin
    Examples:
      | dav-path |
      | old      |
      | new      |


  Scenario Outline: sharee deleting a folder in a group-shared folder moves it to the trashbin of sharee and sharer only
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has created folder "/shared"
    And user "Alice" has created folder "/shared/sub"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/sub/shared_file.txt"
    And user "Alice" has shared folder "/shared" with group "grp1"
    When user "Brian" deletes folder "/shared/sub" using the WebDAV API
    Then as "Brian" the file with original path "/shared/sub/shared_file.txt" should exist in the trashbin
    And as "Alice" the file with original path "/shared/sub/shared_file.txt" should exist in the trashbin
    And as "Carol" the file with original path "/shared/sub/shared_file.txt" should not exist in the trashbin
    Examples:
      | dav-path |
      | old      |
      | new      |


  Scenario Outline: sharer deleting a folder in a group-shared folder moves it to the trashbin of sharer only
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has created folder "/shared"
    And user "Alice" has created folder "/shared/sub"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/sub/shared_file.txt"
    And user "Alice" has shared folder "/shared" with group "grp1"
    When user "Alice" deletes folder "/shared/sub" using the WebDAV API
    Then as "Alice" the file with original path "/shared/sub/shared_file.txt" should exist in the trashbin
    And as "Brian" the file with original path "/shared/sub/shared_file.txt" should not exist in the trashbin
    And as "Carol" the file with original path "/shared/sub/shared_file.txt" should not exist in the trashbin
    Examples:
      | dav-path |
      | old      |
      | new      |


  Scenario Outline: deleting a file in a received folder when restored it comes back to the original path
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/shared"
    And user "Alice" has uploaded file with content "to delete" to "/shared/shared_file.txt"
    And user "Alice" has shared folder "/shared" with user "Brian"
    And user "Brian" has moved file "/shared" to "/renamed_shared"
    And user "Brian" has deleted file "/renamed_shared/shared_file.txt"
    When user "Brian" restores the file with original path "/renamed_shared/shared_file.txt" using the trashbin API
    Then the HTTP status code should be "201"
    And the following headers should match these regular expressions for user "Brian"
      | ETag | /^"[a-f0-9:\.]{1,32}"$/ |
    And as "Brian" the file with original path "/renamed_shared/shared_file.txt" should not exist in the trashbin
    And user "Brian" should see the following elements
      | /renamed_shared/                |
      | /renamed_shared/shared_file.txt |
    And the content of file "/renamed_shared/shared_file.txt" for user "Brian" should be "to delete"
    Examples:
      | dav-path |
      | old      |
      | new      |

  @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
  Scenario Outline: restoring a file to a read-only folder
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Brian" has created folder "shareFolderParent"
    And user "Brian" has shared folder "shareFolderParent" with user "Alice" with permissions "read"
    And as "Alice" folder "/shareFolderParent" should exist
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has deleted file "/textfile0.txt"
    When user "Alice" restores the file with original path "/textfile0.txt" to "/shareFolderParent/textfile0.txt" using the trashbin API
    Then the HTTP status code should be "403"
    And as "Alice" the file with original path "/textfile0.txt" should exist in the trashbin
    And as "Alice" file "/shareFolderParent/textfile0.txt" should not exist
    And as "Brian" file "/shareFolderParent/textfile0.txt" should not exist
    Examples:
      | dav-path |
      | old      |
      | new      |

  @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
  Scenario Outline: restoring a file to a read-only sub-folder
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Brian" has created folder "shareFolderParent"
    And user "Brian" has created folder "shareFolderParent/shareFolderChild"
    And user "Brian" has shared folder "shareFolderParent" with user "Alice" with permissions "read"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And as "Alice" folder "/shareFolderParent/shareFolderChild" should exist
    And user "Alice" has deleted file "/textfile0.txt"
    When user "Alice" restores the file with original path "/textfile0.txt" to "/shareFolderParent/shareFolderChild/textfile0.txt" using the trashbin API
    Then the HTTP status code should be "403"
    And as "Alice" the file with original path "/textfile0.txt" should exist in the trashbin
    And as "Alice" file "/shareFolderParent/shareFolderChild/textfile0.txt" should not exist
    And as "Brian" file "/shareFolderParent/shareFolderChild/textfile0.txt" should not exist
    Examples:
      | dav-path |
      | old      |
      | new      |
