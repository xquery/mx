
xquery version "1.0-ml";

import module namespace usermodule = "http://www.marklogic.com/usermodule" at "../usermodule.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

xdmp:set-response-content-type("application/xml; charset=utf-8"),

let $userid := xdmp:get-request-field("id")
let $xml-header := '<?xml version="1.0" encoding="UTF-8" ?>'
let $method := xdmp:get-request-method()

return
    try {
        sec:check-admin(),
        $xml-header,
        if($method = 'GET') then
            usermodule:list-users($userid)
        else
            usermodule:update-user($userid, xdmp:get-request-body())
    }catch($e){
        <error>no access</error>
    }
