xquery version "1.0-ml" encoding "utf-8";
(: -------------------------------------------------------------------------------------------------------- :)
module namespace mx = "http://www.marklogic.com/mx";

(: -------------------------------------------------------------------------------------------------------- :)

(: namespaces :)
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

(: prolog, options :)
declare copy-namespaces no-preserve, no-inherit;
declare option xdmp:mapping "true";

(: config :)
declare variable $mx:controller-path      as xs:string := '/mx-controller.xqy';
declare variable $mx:mustache-path        as xs:string := '/lib/mustache.xq/mustache.xq';
declare variable $mx:mljson-path        as xs:string := '/lib/mljson/lib/json.xqy';
declare variable $mx:default-content-type as xs:string := 'application/xml';
declare variable $mx:default-type         as xs:string := 'inline';
    
(: mode set with mx-controller.xqy invoke :)
declare variable $mx:mode as xs:string := xdmp:get-request-field('mode','rewrite');

(: assertions, logging :)
declare variable $mx:LOG-LEVEL as xs:string  := "fine";
declare variable $mx:log-flag  as xs:boolean := fn:true(); 
declare variable $mx:assert    as xs:boolean := fn:true();

(: flags - to permanantly disable any of these behaviors set to fn:false() :)
declare variable $mx:flush-flag   as xs:boolean := ((xdmp:get-request-field('flush') eq 'true'),fn:true())[1]; 
declare variable $mx:debug-flag   as xs:boolean := ((xdmp:get-request-field('debug') eq 'true'),fn:false())[1]; 
declare variable $mx:profile-flag as xs:boolean := ((xdmp:get-request-field('profile') eq 'true'),fn:false())[1];  
declare variable $mx:doc-flag     as xs:boolean := ((xdmp:get-request-field('doc') eq 'true'),fn:false())[1]; 
declare variable $mx:cache-flag   as xs:boolean := ((xdmp:get-request-field('cache') eq 'true'),fn:true())[1];  

(: HOX :)
declare variable $mx:handle-response := xdmp:function(xs:QName('mx:handle-response'));
declare variable $mx:dispatch        := xdmp:function(xs:QName('mx:dispatch'));
declare variable $mx:memoize         := xdmp:function(xs:QName('mx:memoize'));
declare variable $mx:mustache        := xdmp:function(fn:QName('mustache.xq','render'), $mx:mustache-path);
declare variable $mx:xmlToJSON       := xdmp:function(fn:QName('http://marklogic.com/json','xmlToJSON'), $mx:mljson-path);
declare variable $mx:jsonToXML       := xdmp:function(fn:QName('http://marklogic.com/json','jsonToXML'), $mx:mljson-path);

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
    if ($querystring) then fn:concat($match,'&amp;',$querystring) else $match
  else if($match/@type eq 'redirect') then
    mx:constructURL($mx:controller-path, $querystring,
             (<param name='mode' value='redirect'/>, 
              <param name='type' value='{$match/@type}'/>,
              <param name='url' value='{$match}'/>))
  else if($match) then
    mx:constructURL($mx:controller-path, $querystring,
             (<param name='mode' value='handler'/>, 
              <param name='url' value='{$requestURL}'/>,
              <param name='href' value='{$match/@href}'/>,
              <param name='ns' value='{$match/@ns}'/>,
              <param name='type' value='{$match/@type}'/>,
              <param name='model' value='{$match/@data}'/>,
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
    let $log := mx:log(('mx:handle-request ',$req))
    let $path         as xs:string        := ($req/*:params/*:url, '/mx')[1]
    let $match        as element(mx:path) := map:get($app-map, $path)
    let $convert      as xs:string        := ($req/*:params/*:convert, '')[1]
    let $content-type as xs:string        := ($match/@content-type,$mx:default-content-type)[1]
    return
      if ($match and $content-type eq 'application/json' and $convert eq 'xml2json') then
        mx:handle-response($content-type, xdmp:apply( $mx:xmlToJSON, xdmp:apply($mx:memoize, $mx:dispatch, $req, $match) ) )
      else if($match and $content-type eq 'application/xml' and $convert eq 'json2xml') then
        mx:handle-response($content-type, xdmp:apply( $mx:jsonToXML, xdmp:apply($mx:memoize, $mx:dispatch, $req, $match) ) )        
      else if($match) then
        mx:handle-response($content-type, xdmp:apply($mx:memoize, $mx:dispatch, $req, $match) )
      else
        mx:handle-error($req)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:dispatch($req,$match) as item()* {
(: -------------------------------------------------------------------------------------------------------- :)
    let $log := mx:log(('mx:dispatch ',$match))
    let $type  as xs:string  := ($req/*:params/*:type, $mx:default-type)[1]
    let $model as xs:string  := ($req/*:params/*:model, '')[1]
    let $href  as xs:string  := ($req/*:params/*:href, '')[1]
    let $ns    as xs:string  := ($req/*:params/*:ns, '')[1]
    let $path  as xs:string  := ($req/*:params/*:url, '/mx')[1]
    return
      if ($model ne '' and $type eq 'template') then
        if ($match/xsl:stylesheet) then
          xdmp:xslt-eval($match/xsl:stylesheet, mx:data($model,$req/*:params/*))
        else
          xdmp:apply( $mx:mustache, xdmp:quote($match/node()), xdmp:quote(mx:data($model,$req/*:params/*)))
      else if ($href ne '' and $match/*:arg and fn:contains($href,'#')) then
        mx:invoke($href,for $arg in $match/*:arg return $arg/node(), $ns)
      else if ($href ne '') then
        mx:invoke($href,for $arg in $match/*:arg return $arg/node())
      else if ($type eq '' or $type eq 'inline') then
        mx:eval(xdmp:quote($match/node()))
      else
          ()
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-response($content-type, $content) as item()* {
(: -------------------------------------------------------------------------------------------------------- :)
	(xdmp:set-response-content-type($content-type),$content)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-error($req) as element(mx:error){
(: -------------------------------------------------------------------------------------------------------- :)
<mx:error xdmp-request="{xdmp:request()}">
    {$req}
</mx:error>
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:handle-debug($req as element(mx:request),$app-map as map:map) as element(mx:debug){
(: -------------------------------------------------------------------------------------------------------- :)
<mx:debug xdmp-request="{xdmp:request()}">
    {$req}
    {if($mx:profile-flag) then xdmp:query-meters() else ()}
</mx:debug>
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:invoke($href as xs:string){
(: -------------------------------------------------------------------------------------------------------- :)
 xdmp:invoke($href)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:invoke($href as xs:string, $vars as item()*){
(: -------------------------------------------------------------------------------------------------------- :)
 xdmp:invoke($href)
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:invoke($href as xs:string, $vars as item()*, $ns){
(: -------------------------------------------------------------------------------------------------------- :)
let $arity    as xs:integer := fn:count($vars)
let $module   as xs:string  := fn:substring-before($href,'#')
let $func     as xs:string  := fn:substring-after($href,'#')
let $function :=  xdmp:function(fn:QName($ns,$func), $module)
return
  if ($arity eq 1) then
    xdmp:apply( $function, $vars)
  else if ($arity eq 2) then
    xdmp:apply( $function, $vars[1], $vars[2])
  else if ($arity eq 3) then
    xdmp:apply( $function, $vars[1], $vars[2], $vars[3])
  else if ($arity eq 4) then
    xdmp:apply( $function, $vars[1], $vars[2], $vars[3], $vars[4])
  else if ($arity eq 5) then
    xdmp:apply( $function, $vars[1], $vars[2], $vars[3], $vars[4], $vars[5])
  else
    ()
};


(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:delete-cache() {
(: -------------------------------------------------------------------------------------------------------- :)
xdmp:set-server-field('mx:cache',())
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:cache() {
(: -------------------------------------------------------------------------------------------------------- :)
if (fn:empty(xdmp:get-server-field('mx:cache'))) then 
  let $cache as map:map := map:map()
  let $serverfield := xdmp:set-server-field('mx:cache',$cache)
  return
    $cache
else
  xdmp:get-server-field('mx:cache')
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:delete-map() {
(: -------------------------------------------------------------------------------------------------------- :)
xdmp:set-server-field('mx:map',())
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:map() {
(: -------------------------------------------------------------------------------------------------------- :)
    xdmp:get-server-field('mx:map')
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:map($app) as map:map{
(: -------------------------------------------------------------------------------------------------------- :)
if(fn:empty( mx:map() ) or $mx:flush-flag eq fn:true()) then
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
  mx:map()

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
declare function mx:param($name as xs:string) as item()*{
(: -------------------------------------------------------------------------------------------------------- :)
    mx:get-request()/*:params/*[fn:local-name(.) eq $name]/node()
};
(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:session($name as xs:string) as item()*{
(: -------------------------------------------------------------------------------------------------------- :)
    mx:get-request()/*:session-fields/*[fn:local-name(.) eq $name]/node()
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:data($path as xs:string) as item()*{
(: -------------------------------------------------------------------------------------------------------- :)
    let $app-map as map:map          := mx:map()
    let $match   as element(mx:path) := map:get($app-map, $path)
    let $content-type as xs:string   := ($match/@content-type,'')[1]
    let $href    as xs:string        := ($match/@href,'')[1]
    let $ns      as xs:string        := ($match/@ns,'')[1]
    let $url     as xs:string        := ($match/@url,'')[1]
    let $type    as xs:string        := ($match/@type,'')[1]
    let $model   as xs:string        := ($match/@data,'')[1]
      return
     mx:handle-request(<request content-type="{$content-type}" xmlns="http://www.marklogic.com/mx">
     <params>
       <model>{$model}</model>
       <ns>{$ns}</ns>
       <href>{$href}</href>
       <url>{$url}</url>
       <type>{$type}</type>
     </params></request>,
     $app-map )
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:data($path as xs:string, $params as item()*) as item()*{
(: -------------------------------------------------------------------------------------------------------- :)
    let $log := mx:log(('mx:data ',$path, $params))
    let $app-map as map:map          := mx:map()
    let $match   as element(mx:path) := map:get($app-map, $path)
    let $content-type as xs:string   := ($match/@content-type,'')[1]
    let $href    as xs:string        := ($match/@href,'')[1]
    let $ns      as xs:string        := ($match/@ns,'')[1]
    let $url     as xs:string        := ($match/@url,'')[1]
    let $type    as xs:string        := ($match/@type,'')[1]
    let $model   as xs:string        := ($match/@data,'')[1]
      return
     mx:handle-request(<request content-type="{$content-type}" xmlns="http://www.marklogic.com/mx">
     <params>
       <model>{$model}</model>
       <ns>{$ns}</ns>
       <href>{$href}</href>
       <url>{$url}</url>
       <type>{$type}</type>
       {for $param in $params return 
       if (fn:name($param) eq ('url','type','model','ns','href')) then
         ()
       else
         element {fn:QName('http://www.marklogic.com/mx',fn:local-name($param))} {$param/node()}}
         </params></request>,
         $app-map )
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:eval($query as xs:string){
(: -------------------------------------------------------------------------------------------------------- :)
 let $preamble := 'import module namespace mx = "http://www.marklogic.com/mx" at 
              "/lib/mx.xqm";
    import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
    
              declare namespace xdmp = "http://marklogic.com/xdmp";
              '
return
  xdmp:eval(fn:concat($preamble,$query))
};

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:memoize($func,$req, $content){
(: -------------------------------------------------------------------------------------------------------- :)
  let $cache as map:map   := mx:cache()
  let $key   as xs:string := xdmp:md5(fn:concat($func,xdmp:quote($content),xdmp:quote($req/*:params))) 
  return 
    if(map:get($cache,$key) and $mx:cache-flag) then
      (map:get($cache,$key), mx:log(fn:concat('mx:cache key hit:',$key)))
    else 
      let $result := xdmp:apply($func,$req,$content)
      let $put :=  map:put($cache,$key,$result)
      let $serverfield := xdmp:set-server-field('mx:cache',$cache)
      return 
        ($result,mx:log(fn:concat('mx:cache key generated: ',$key)))
 }; 

(: -------------------------------------------------------------------------------------------------------- :)
declare function mx:log($message){
(: -------------------------------------------------------------------------------------------------------- :)
   if($mx:log-flag) then
     xdmp:log(fn:concat('MX LOG: ', xdmp:quote($message)))
   else
     ()
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



