xquery version "1.0-ml";

declare default element namespace "http://www.w3.org/1999/xhtml";

import module namespace usermodule="http://www.marklogic.com/usermodule" at "../usermodule.xqy";


xdmp:set-response-content-type("application/xml; charset=utf-8"),
let $login := usermodule:login("admin","123")
return
    let $groups := ("admin")

return
	if (usermodule:check-access($groups)) then
	   <result><access>yes</access></result>
	else
       <result><access>no</access></result>
