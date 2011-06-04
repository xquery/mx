xquery version "1.0-ml" encoding "utf-8";
(: -------------------------------------------------------------------------------------------------------- :)
module namespace mx = "http://www.marklogic.com/mx";

(: -------------------------------------------------------------------------------------------------------- :)
declare namespace req ="http://marklogic.com/mvc/request";

(: -------------------------------------------------------------------------------------------------------- :)

(: options :)
declare option xdmp:mapping "true";

(: default config :)
declare variable $mx:controller-name      as xs:string := 'mx-controller.xqy';
declare variable $mx:default-content-type as xs:string := 'application/xml';

(: mode is set when mx-controller.xqy is called :)
declare variable $mx:mode as xs:string := xdmp:get-request-field('mode','rewrite');

(: assertions, logging :)
declare variable $mx:LOG-LEVEL as xs:string  := "fine";
declare variable $mx:assert    as xs:boolean := fn:true();

(: flags - to permanantly disable any of these behaviors set to fn:false() :)
declare variable $mx:flush-flag   as xs:boolean := ((xdmp:get-request-field('flush') eq 'true'),fn:false())[1]; 
declare variable $mx:debug-flag   as xs:boolean := ((xdmp:get-request-field('debug') eq 'true'),fn:false())[1]; 
declare variable $mx:profile-flag as xs:boolean := ((xdmp:get-request-field('profile') eq 'true'),fn:false())[1];  
declare variable $mx:doc-flag     as xs:boolean := ((xdmp:get-request-field('doc') eq 'true'),fn:false())[1]; 
declare variable $mx:cache-flag   as xs:boolean := ((xdmp:get-request-field('cache') eq 'true'),fn:true())[1];  

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:map($app) as map:map{
(: -------------------------------------------------------------------------------------------------------- :)
if(fn:empty(xdmp:get-server-field('mx:map')) or $mx:flush-flag eq fn:true()) then
    let $map as map:map := map:map()
    let $build-passthru-map := map:put($map,'passthru',for $path in $app//*:path[@type eq 'passthru']
                                                       return 
                                                         fn:concat('^',$path/@url,
                                                             if(fn:ends-with($path/@url,'/')) then '*' else '$'))
    let $build-redirect-map := for $path in $app//*:path[@type eq 'redirect']
                                                       return 
                                                         map:put($map,$path/@url,$path)
    let $build-forward-map := for $path in $app//*:path[@type eq 'forward']
                                                       return 
                                                         map:put($map,$path/@url,$path)
    let $build-map := for $path in $app//*:path[@method]
                                                       return 
                                                         map:put($map,$path/@url,$path)
    let $serverfield := xdmp:set-server-field('mx:map',$map)                                                     
    return
      $map
else
  xdmp:get-server-field('mx:map')
};

(: -------------------------------------------------------------------------------------------------------- :)
  declare function mx:rewrite($requestURL as xs:string, $app-map as map:map) as xs:string {
(: -------------------------------------------------------------------------------------------------------- :)
  let $app-paths :=   map:keys($app-map)  
  let $passthru  :=   map:get($app-map, 'passthru')
  let $match     :=   map:get($app-map, if(fn:contains($requestURL,'?')) then fn:substring-before($requestURL,'?') else $requestURL)  
  return
  if ( fn:matches($requestURL,$passthru)) then
    $requestURL
  else if($match and $match/@type eq 'forward') then
    $match/text()
  else if($match and $match/@type eq 'redirect') then
    fn:concat('/',$mx:controller-name,'?mode=redirect&amp;url=',$match/text())
  else if($match) then
   let $path         as xs:string := fn:string($match/@url)
   let $model        as xs:string := fn:string($match/@model)
   let $content-type as xs:string := fn:string($match/@content-type)
   let $method       as xs:string := (fn:string($match/@method),'GET')[1]
   let $type         as xs:string := (fn:string($match/@type),'inline')[1]
   let $querystring  as xs:string :=  fn:string-join( for $param in xdmp:get-request-field-names()
      where fn:not(fn:exists(xdmp:get-request-field-content-type($param)))
      return
         fn:concat($param,"=",xdmp:get-request-field($param)), "&amp;")
         return
           fn:concat('/',$mx:controller-name,
           '?mode=handler&amp;url=',$path,
           '&amp;content-type=',$content-type,
           '&amp;type=',$type,
           '&amp;model=',$model,
           '&amp;method=',$method,
           '&amp;',$querystring)
  else
   let $querystring :=  fn:string-join( for $param in xdmp:get-request-field-names()
      where fn:not(fn:exists(xdmp:get-request-field-content-type($param)))
      return
         fn:concat($param,"=",xdmp:get-request-field($param)), "&amp;")
     return
      fn:concat('/',$mx:controller-name,'?mode=error&amp;',$querystring)   
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-request($req as element(req:request), $app-map as map:map){
(: -------------------------------------------------------------------------------------------------------- :)
if ($debug-flag eq fn:true()) then
    mx:handle-debug($req, $app-map)
else
    let $type         as xs:string := $req/req:params/req:type/req:value
    let $path         as xs:string := $req/req:params/req:url/req:value
    let $inline       := map:get($app-map, $path)
    let $content-type as xs:string := ($inline/@content-type,$mx:default-content-type)[1]
    return
      if ($type eq 'inline') then
          mx:handle-response($content-type,
                $inline/node() )
      else
          mx:handle-response($content-type,
                 mx:dispatch($req, $app-map) )
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:dispatch($req as element(req:request), $app-map as map:map){
(: -------------------------------------------------------------------------------------------------------- :)
if ($profile-flag) then
    prof:eval('let $a := 1 return <test>{$a}</test>', (), ())
else
    <handle-request>
    {$req}
    </handle-request>
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-error($req) as element(error){
(: -------------------------------------------------------------------------------------------------------- :)
<error>
    {$req}
</error>
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-debug($req as element(req:request),$app-map as map:map){
(: -------------------------------------------------------------------------------------------------------- :)
<debug xdmp-request="{xdmp:request()}">
    {$req}
    {if($mx:cache-flag) then xdmp:query-meters() else ()}
    {
    let $type := $req//*:type/*:value
    let $path := $req//*:url/*:value
    return
      if ($type eq 'inline') then
        let $inline       := map:get($app-map, $path)
        let $content-type := ($inline/@content-type,$mx:default-content-type)[1]
        return
          $inline/node()
        else      
          mx:dispatch($req,$app-map)}
</debug>
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:invoke(){
(: -------------------------------------------------------------------------------------------------------- :)
 ()
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-response($content-type, $content) as item()*
(: -------------------------------------------------------------------------------------------------------- :)
{
	(xdmp:set-response-content-type($content-type),$content)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:view($type as xs:string, $res, $template){
(: -------------------------------------------------------------------------------------------------------- :)
    ()
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function _view-xlst($res,$template,$params){
(: -------------------------------------------------------------------------------------------------------- :)
    ()
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function _view-xquery($res,$template,$params){
(: -------------------------------------------------------------------------------------------------------- :)
    ()
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function _view-mustache($res,$template,$params){
(: -------------------------------------------------------------------------------------------------------- :)
    ()
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:get-request()
(: -------------------------------------------------------------------------------------------------------- :)
as element(req:request)
{
  element {fn:QName("http://marklogic.com/mvc/request","request")} {
    attribute method {fn:upper-case(xdmp:get-request-method())},
    attribute rewrite-url {xdmp:get-request-url()},
    attribute protocol {xdmp:get-request-protocol()},
    attribute client-ip {xdmp:get-request-client-address()},
    element req:status-code {200},
    element req:message {"OK"},
    element req:session {
      for $field in xdmp:get-session-field-names()
      return
        element {fn:concat("req:",fn:lower-case($field))} {
          xdmp:get-session-field($field)
        }
    },
    element req:params {
      for $param in xdmp:get-request-field-names()
      where fn:not(fn:exists(xdmp:get-request-field-content-type($param)))
      return
        element {fn:concat("req:",fn:lower-case($param))} {
          attribute content-type {xdmp:get-request-field-content-type($param)},
          for $value in xdmp:get-request-field($param) return element req:value {$value}
        }
    },
    element req:files {
      for $param in xdmp:get-request-field-names()
      let $content-type := xdmp:get-request-field-content-type($param)
      where fn:exists($content-type)
      return
        element {fn:concat("req:",fn:lower-case($param))} {
          attribute content-type {$content-type},
          attribute name {xdmp:get-request-field-filename($param)},
          if ($content-type eq "text/plain") then
            xdmp:get-request-field($param)[1]
          else ()
        }
    },
    element req:header {
      for $header in xdmp:get-request-header-names()
       return
        element {fn:concat("req:",fn:lower-case($header))} {
          xdmp:get-request-header($header)
        }
    },
    element req:body {
      attribute content-type {xdmp:get-request-header("content-type")},
      if (xdmp:get-request-body()/node() instance of element()) then
        xdmp:get-request-body()/node()
      else () 
    }
  }
};



