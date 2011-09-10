xquery version "1.0-ml" encoding "utf-8";

(: -------------------------------------------------------------------------------------------------------- :)
import module namespace mx = "http://www.marklogic.com/mx" at "/lib/mx.xqm";

(: -------------------------------------------------------------------------------------------------------- :)

(: load up app.xml:)
declare variable $mx:app := mx:map( xdmp:document-get('/Users/jfuller/Source/Webcomposite/mx/src/test-app/app.xml'));

(: -------------------------------------------------------------------------------------------------------- :)
if( $mx:mode eq 'rewrite' ) then              
  mx:rewrite( xdmp:get-request-url(), $mx:app )
else if( $mx:mode eq 'redirect' ) then           
  xdmp:redirect-response( xdmp:get-request-field('url'))  (: TODO - need to pass url params to new URL :)
else if( $mx:mode eq 'error' ) then           
  mx:handle-error(mx:get-request())
else               
  mx:handle-request(mx:get-request(), $mx:app ) 

(: -------------------------------------------------------------------------------------------------------- :)
