Feature: transfer-ownership

	# TODO: change to @no_default_encryption once all this works with master key
	@no_encryption
	Scenario: transfering ownership of a file
		Given user "user0" exists
		And user "user1" exists
		And User "user0" uploads file "data/textfile.txt" to "/somefile.txt"
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user1"
		And using received transfer folder of "user1" as dav path
		Then Downloaded content when downloading file "/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of a folder
		Given user "user0" exists
		And user "user1" exists
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user1"
		And using received transfer folder of "user1" as dav path
		Then Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of file shares
		Given user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And User "user0" uploads file "data/textfile.txt" to "/somefile.txt"
		And file "/somefile.txt" of user "user0" is shared with user "user2" with permissions 19
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user2"
		Then Downloaded content when downloading file "/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of folder shared with third user
		Given user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		And folder "/test" of user "user0" is shared with user "user2" with permissions 31
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user2"
		Then Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of folder shared with transfer recipient
		Given user "user0" exists
		And user "user1" exists
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		And folder "/test" of user "user0" is shared with user "user1" with permissions 31
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user1"
		Then as "user1" the folder "/test" does not exist
		And using received transfer folder of "user1" as dav path
		And Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of folder doubly shared with third user
		Given group "group1" exists
		And user "user0" exists
		And user "user1" exists
		And user "user2" exists
    	And user "user2" belongs to group "group1"
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		And folder "/test" of user "user0" is shared with group "group1" with permissions 31
		And folder "/test" of user "user0" is shared with user "user2" with permissions 31
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user2"
		Then Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership does not transfer received shares
		Given user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And User "user2" created a folder "/test"
		And folder "/test" of user "user2" is shared with user "user0" with permissions 31
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user1"
		And using received transfer folder of "user1" as dav path
		Then as "user1" the folder "/test" does not exist

	@no_encryption
	@local_storage
	Scenario: transfering ownership does not transfer external storage
		Given user "user0" exists
		And user "user1" exists
		When transfering ownership from "user0" to "user1"
		And the command was successful
		And As an "user1"
		And using received transfer folder of "user1" as dav path
		Then as "user1" the folder "/local_storage" does not exist

	@no_encryption
	Scenario: transfering ownership does not fail with shared trashed files
		Given user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And User "user0" created a folder "/sub"
		And User "user0" created a folder "/sub/test"
		And folder "/sub/test" of user "user0" is shared with user "user2" with permissions 31
		And User "user0" deletes folder "/sub"
		When transfering ownership from "user0" to "user1"
		Then the command was successful

	@no_encryption
	Scenario: transfering ownership fails with invalid source user
		Given user "user0" exists
		When transfering ownership from "invalid_user" to "user0"
		Then the command error output contains the text "Unknown source user"
		And the command failed with exit code 1

	@no_encryption
	Scenario: transfering ownership fails with invalid target user
		Given user "user0" exists
		When transfering ownership from "user0" to "invalid_user"
		Then the command error output contains the text "Unknown target user"
		And the command failed with exit code 1

	@no_encryption
	Scenario: transfering ownership of a folder
		Given user "user0" exists
		And user "user1" exists
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		When transfering ownership of path "test" from "user0" to "user1"
		And the command was successful
		And As an "user1"
		And using received transfer folder of "user1" as dav path
		Then Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of file shares
		Given user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		And file "/test/somefile.txt" of user "user0" is shared with user "user2" with permissions 19
		When transfering ownership of path "test" from "user0" to "user1"
		And the command was successful
		And As an "user2"
		Then Downloaded content when downloading file "/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of folder shared with third user
		Given user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		And folder "/test" of user "user0" is shared with user "user2" with permissions 31
		When transfering ownership of path "test" from "user0" to "user1"
		And the command was successful
		And As an "user2"
		Then Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of folder shared with transfer recipient
		Given user "user0" exists
		And user "user1" exists
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		And folder "/test" of user "user0" is shared with user "user1" with permissions 31
		When transfering ownership of path "test" from "user0" to "user1"
		And the command was successful
		And As an "user1"
		Then as "user1" the folder "/test" does not exist
		And using received transfer folder of "user1" as dav path
		And Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership of folder doubly shared with third user
		Given group "group1" exists
		And user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And user "user2" belongs to group "group1"
		And User "user0" created a folder "/test"
		And User "user0" uploads file "data/textfile.txt" to "/test/somefile.txt"
		And folder "/test" of user "user0" is shared with group "group1" with permissions 31
		And folder "/test" of user "user0" is shared with user "user2" with permissions 31
		When transfering ownership of path "test" from "user0" to "user1"
		And the command was successful
		And As an "user2"
		Then Downloaded content when downloading file "/test/somefile.txt" with range "bytes=0-6" should be "This is"

	@no_encryption
	Scenario: transfering ownership does not transfer received shares
		Given user "user0" exists
		And user "user1" exists
		And user "user2" exists
		And User "user2" created a folder "/test"
		And User "user0" created a folder "/sub"
		And folder "/test" of user "user2" is shared with user "user0" with permissions 31
		And User "user0" moved folder "/test" to "/sub/test"
		When transfering ownership of path "sub" from "user0" to "user1"
		And the command was successful
		And As an "user1"
		And using received transfer folder of "user1" as dav path
		Then as "user1" the folder "/sub/test" does not exist

	@no_encryption
	@local_storage
	Scenario: transfering ownership does not transfer external storage
		Given user "user0" exists
		And user "user1" exists
		And User "user0" created a folder "/sub"
		When transfering ownership of path "sub" from "user0" to "user1"
		And the command was successful
		And As an "user1"
		And using received transfer folder of "user1" as dav path
		Then as "user1" the folder "/local_storage" does not exist

	@no_encryption
	Scenario: transfering ownership fails with invalid source user
		Given user "user0" exists
		And User "user0" created a folder "/sub"
		When transfering ownership of path "sub" from "invalid_user" to "user0"
		Then the command error output contains the text "Unknown source user"
		And the command failed with exit code 1

	@no_encryption
	Scenario: transfering ownership fails with invalid target user
		Given user "user0" exists
		And User "user0" created a folder "/sub"
		When transfering ownership of path "sub" from "user0" to "invalid_user"
		Then the command error output contains the text "Unknown target user"
		And the command failed with exit code 1

	@no_encryption
	Scenario: transfering ownership fails with invalid path
		Given user "user0" exists
		And user "user1" exists
		When transfering ownership of path "test" from "user0" to "user1"
		Then the command error output contains the text "Unknown target user"
		And the command failed with exit code 1
