xquery version "1.0-ml" encoding "utf-8";



let $setup-users := xdmp:eval( '

import module namespace usermodule = "http://www.marklogic.com/usermodule" at "/lib/usermodule/usermodule.xqy";
(usermodule:create-user-details("test","123","Mark","Logic","test@test.org","123"),
usermodule:create-user-details("admin","123","Mark","Logic","admin@test.org","123"))
')
let $setup-groups := xdmp:eval('
import module namespace usermodule = "http://www.marklogic.com/usermodule" at "/lib/usermodule/usermodule.xqy";
(usermodule:create-group("admin"),
usermodule:create-group("editor"),
usermodule:create-group("public") )
')


let $add-user-to-group := xdmp:eval('
import module namespace usermodule = "http://www.marklogic.com/usermodule" at "/lib/usermodule/usermodule.xqy";
(usermodule:user-add-group("admin","admin"),
usermodule:user-add-group("admin","editor"),
usermodule:user-add-group("admin","public"),
usermodule:user-add-group("test","public"))
')

return
<success/>
