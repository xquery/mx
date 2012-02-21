xquery version "1.0-ml" encoding "utf-8";

(: -------------------------------------------------------------------------------------------------------- :)
import module namespace mx = "http://www.marklogic.com/mx" at "/lib/mx-0.1/mx.xqm";
(: -------------------------------------------------------------------------------------------------------- :)

(: load up app.xml:)
declare variable $mx:app := mx:map(
<app xmlns="http://www.marklogic.com/mx" xmlns:mx="http://www.marklogic.com/mx" default-context="?">

  <!-- passthru  //-->
  <path url="/resource/" type="passthru" description=""/>
  <path url="/robots.txt" type="passthru" description=""/>

  <path url="/inline.test" method="GET">
    <html>
      <body>
        <h1>inline test</h1>
      </body>
    </html>
  </path>
  <path url="/inline4.test" type="inline" content-type="text/html" method="GET"
        description="show embedded xquery">
    <html>
      <body>
        <h1>inline test</h1>
        <p>{fn:current-time()}</p>
      </body>
    </html>
  </path>

</app>

);

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
