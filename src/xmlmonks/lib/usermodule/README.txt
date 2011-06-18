----------
UserModule 
----------

This module provides application level authentication and maintains its own set of user/groups. This is an alternative to using ML own
user groups and is appropriate for simple applications.

-----------------
Installation
-----------------

1. Place the usermodule.xqy xquery library file in the Modules directory or filesystem.
3. Enable application level authentication 
	a. Go to the HTTP Server
	b. Select authentication = application-level
	c. default user = setup ML user for your app
	d. Save
5. follow examples under test directory


-----------------
Example Queries
-----------------

import module namespace usermodule = "http://www.marklogic.com/usermodule" at "/lib/usermodule/usermodule.xqy";


--------------------------
add users
--------------------------

(usermodule:create-user-details("test","123","Mark","Logic","test@test.org","123"),
usermodule:create-user-details("admin","123","Mark","Logic","admin@test.org","123"))

--------------------------
add groups
--------------------------

(usermodule:create-group("admin"),
usermodule:create-group("editor"),
usermodule:create-group("public") )

--------------------------
add users to groups
--------------------------

(usermodule:user-add-group("admin","admin"),
usermodule:user-add-group("admin","editor"),
usermodule:user-add-group("admin","public"),
usermodule:user-add-group("test","public"))

--------------------------
queries to get data on user(s)
--------------------------

usermodule:get-user("admin")

usermodule:list-all-users()

xdmp:directory('/user/')

xdmp:directory('/group/')
