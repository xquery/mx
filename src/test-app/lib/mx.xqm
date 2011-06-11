xquery version "1.0-ml" encoding "utf-8";
(: -------------------------------------------------------------------------------------------------------- :)
module namespace mx = "http://www.marklogic.com/mx";

(: -------------------------------------------------------------------------------------------------------- :)

(: options :)
declare option xdmp:mapping "true";

(: default config :)
declare variable $mx:controller-path      as xs:string := '/mx-controller.xqy';
declare variable $mx:default-content-type as xs:string := 'application/xml';
declare variable $mx:default-type         as xs:string := 'inline';

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
declare function mx:map() {
(: -------------------------------------------------------------------------------------------------------- :)
    xdmp:get-server-field('mx:map')
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:map($app) as map:map{
(: -------------------------------------------------------------------------------------------------------- :)
if(fn:empty(xdmp:get-server-field('mx:map')) or $mx:flush-flag eq fn:true()) then
    let $map as map:map := map:map()
    let $build-passthru-map := map:put($map,'passthru',for $path in $app//mx:path[@type eq 'passthru']
                                                       return 
                                                         fn:concat('^',$path/@url,
                                                             if(fn:ends-with($path/@url,'/')) then '*' else '$'))
    let $build-redirect-map := for $path in $app//mx:path[@type eq 'redirect']
                                                       return 
                                                         map:put($map,$path/@url,$path)
    let $build-forward-map := for $path in $app//mx:path[@type eq 'forward']
                                                       return 
                                                         map:put($map,$path/@url,$path)
    let $build-map := for $path in $app//mx:path[@method]
                                                       return 
                                                         map:put($map,$path/@url,$path)
    let $serverfield := xdmp:set-server-field('mx:map',$map)                                                     
    return
      $map
else
  xdmp:get-server-field('mx:map')
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:constructURL($urlPath as xs:string, $querystring as xs:string, $addParam as element(param)* ) as xs:string{
(: -------------------------------------------------------------------------------------------------------- :) 
let $paramstring as xs:string := if (fn:empty($addParam)) then '' else fn:string-join(for $param in $addParam
              return
                  fn:concat($param/@name,'=',fn:encode-for-uri($param/@value))
                  ,'&amp;') 
return
  if($paramstring eq '' and $querystring eq '') then
    $urlPath
  else if ($paramstring eq '') then
    fn:concat($urlPath,'?',$querystring)
  else if ($querystring eq '') then
    fn:concat($urlPath,'?',$paramstring)
  else
    fn:concat($urlPath,'?',$querystring,'&amp;',$paramstring)
};

(: -------------------------------------------------------------------------------------------------------- :)
  declare function mx:rewrite($originalURL as xs:string, $app-map as map:map) as xs:string {
(: -------------------------------------------------------------------------------------------------------- :)
  let $requestURL  as xs:string := if(fn:contains($originalURL,'?')) then fn:substring-before($originalURL,'?') else $originalURL
  let $querystring as xs:string := fn:substring-after($originalURL,'?')
  let $app-paths  as xs:string* := map:keys($app-map)  
  let $passthru   as xs:string* := map:get($app-map, 'passthru')
  let $match      := map:get($app-map, $requestURL)
  return
  if ( fn:matches($requestURL,$passthru)) then
    if ($querystring) then fn:concat($requestURL,'?',$querystring) else $requestURL
  else if($match and $match/@type eq 'forward') then
    if ($querystring) then fn:concat($match,'?',$querystring) else $match
  else if($match and $match/@type eq 'redirect') then
    mx:constructURL($mx:controller-path, $querystring,
             (<param name='mode' value='redirect'/>, 
              <param name='type' value='{$match/@type}'/>,
              <param name='url' value='{$match}'/>))
  else if($match) then
    mx:constructURL($mx:controller-path, $querystring,
             (<param name='mode' value='handler'/>, 
              <param name='url' value='{$requestURL}'/>,
              <param name='type' value='{$match/@type}'/>,
              <param name='model' value='{$match/@model}'/>,
              <param name='content-type' value='{$match/@content-type}'/>,
              <param name='method' value='{$match/@method}'/>))
  else
    mx:constructURL($mx:controller-path, $querystring,
              (<param name='mode' value='error'/>,
               <param name='url' value='{$requestURL}'/>))
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-request($req as element(mx:request), $app-map as map:map){
(: -------------------------------------------------------------------------------------------------------- :)
if ($debug-flag eq fn:true()) then
    mx:handle-debug($req, $app-map)
else
    let $type         as xs:string        := ($req/*:params/*:type, $mx:default-type)[1]
    let $href         as xs:string        := ($req/*:params/*:href, '')[1]
    let $path         as xs:string        := ($req/*:params/*:url, '/mx')[1]
    let $inline       as element(mx:path) := map:get($app-map, $path)
    let $content-type as xs:string        := ($inline/@content-type,$mx:default-content-type)[1]
    return
      if ($href ne '') then
         if ($inline/node()) then
          mx:handle-response($content-type,
                 mx:invoke($href,$inline/node(),()))
           else
          mx:handle-response($content-type,
                 mx:invoke($href))
      else if ($type eq '' or $type eq 'inline') then
          mx:handle-response($content-type,
                mx:eval(xdmp:quote($inline/node())) )
      else
          mx:handle-response($content-type,
                 mx:dispatch($req, $app-map) )
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:dispatch($req as element(mx:request), $app-map as map:map){
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
declare function mx:handle-debug($req as element(mx:request),$app-map as map:map){
(: -------------------------------------------------------------------------------------------------------- :)
<debug xdmp-request="{xdmp:request()}">
    {$req}
    {if($mx:cache-flag) then xdmp:query-meters() else ()}
    {
    let $type := $req/params/type
    let $path := $req/params/url
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
declare function mx:invoke($href as xs:string){
(: -------------------------------------------------------------------------------------------------------- :)
 xdmp:invoke($href)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:invoke($href as xs:string, $function, $vars){
(: -------------------------------------------------------------------------------------------------------- :)
 xdmp:invoke($href)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:data($path as xs:string) {
(: -------------------------------------------------------------------------------------------------------- :)
     mx:handle-request(<request
     content-type="text/xml" xmlns="http://www.marklogic.com/mx"><params><url>{$path}</url><type>inline</type></params></request>,
     xdmp:get-server-field('mx:map') )
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:eval($query as xs:string){
(: -------------------------------------------------------------------------------------------------------- :)
 let $preamble := 'import module namespace mx = "http://www.marklogic.com/mx" at 
              "/lib/mx.xqm";

              declare namespace xdmp = "http://marklogic.com/xdmp";

              '

return
  xdmp:eval(fn:concat($preamble,$query))
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-response($content-type, $content) as item()* {
(: -------------------------------------------------------------------------------------------------------- :)
	(xdmp:set-response-content-type($content-type),$content)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:get-request() as element(mx:request) {
(: -------------------------------------------------------------------------------------------------------- :)
  element mx:request {
    attribute method {fn:upper-case(xdmp:get-request-method())},
    attribute rewrite-url {xdmp:get-request-url()},
    attribute protocol {xdmp:get-request-protocol()},
    attribute client-ip {xdmp:get-request-client-address()},
    element session-fields {
      for $field in xdmp:get-session-field-names()
      return
        element {fn:lower-case($field)} {
          xdmp:get-session-field($field)
        }
    },
    element headers {
      for $header in xdmp:get-request-header-names()
       return
        element {fn:lower-case($header)} {
          xdmp:get-request-header($header)
        }
    },
    element params {
      for $param in xdmp:get-request-field-names()[. ne '']
      where fn:not(fn:exists(xdmp:get-request-field-content-type($param)))
      return
        element {fn:lower-case($param)} {xdmp:get-request-field($param)} 
   },
    element files {
      for $param in xdmp:get-request-field-names()
      let $content-type := xdmp:get-request-field-content-type($param)
      where fn:exists($content-type)
      return
        element {fn:lower-case($param)} {
          attribute name {xdmp:get-request-field-filename($param)},
          if ($content-type eq "text/plain") then
            xdmp:get-request-field($param)[1]
          else ()
        }
    },
    element body {
      attribute content-type {xdmp:get-request-header("content-type")},
      if (xdmp:get-request-body()/node() instance of element()) then
        xdmp:get-request-body()/node()
      else () 
    }
  }
};



