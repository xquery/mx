(: XQuery main module :)

xquery version "1.0-ml";

let $url := xdmp:get-request-url() 
return fn:replace($url, "^/user/(.*)", "/user/?id=$1")