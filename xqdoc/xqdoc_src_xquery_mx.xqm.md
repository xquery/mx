# library module: http://www.marklogic.com/mx


## Table of Contents

* Variables: [$controller-path](#var_controller-path), [$mustache-path](#var_mustache-path), [$mljson-path](#var_mljson-path), [$default-content-type](#var_default-content-type), [$default-type](#var_default-type), [$mode](#var_mode), [$LOG-LEVEL](#var_LOG-LEVEL), [$log-flag](#var_log-flag), [$assert](#var_assert), [$flush-flag](#var_flush-flag), [$debug-flag](#var_debug-flag), [$profile-flag](#var_profile-flag), [$doc-flag](#var_doc-flag), [$cache-flag](#var_cache-flag), [$handle-response](#var_handle-response), [$dispatch](#var_dispatch), [$memoize](#var_memoize), [$mustache](#var_mustache), [$xmlToJSON](#var_xmlToJSON), [$jsonToXML](#var_jsonToXML)
* Functions: [rewrite\#2](#func_rewrite_2), [handle-request\#2](#func_handle-request_2), [dispatch\#2](#func_dispatch_2), [handle-response\#2](#func_handle-response_2), [handle-error\#1](#func_handle-error_1), [handle-debug\#2](#func_handle-debug_2), [invoke\#1](#func_invoke_1), [invoke\#2](#func_invoke_2), [invoke\#3](#func_invoke_3), [delete-cache\#0](#func_delete-cache_0), [cache\#0](#func_cache_0), [delete-map\#0](#func_delete-map_0), [map\#0](#func_map_0), [map\#1](#func_map_1), [constructURL\#3](#func_constructURL_3), [param\#1](#func_param_1), [session\#1](#func_session_1), [data\#1](#func_data_1), [data\#2](#func_data_2), [eval\#1](#func_eval_1), [memoize\#3](#func_memoize_3), [log\#1](#func_log_1), [get-request\#0](#func_get-request_0)


## Variables

### <a name="var_controller-path"/> $controller-path
```xquery
$controller-path as  xs:string
```

### <a name="var_mustache-path"/> $mustache-path
```xquery
$mustache-path as  xs:string
```

### <a name="var_mljson-path"/> $mljson-path
```xquery
$mljson-path as  xs:string
```

### <a name="var_default-content-type"/> $default-content-type
```xquery
$default-content-type as  xs:string
```

### <a name="var_default-type"/> $default-type
```xquery
$default-type as  xs:string
```

### <a name="var_mode"/> $mode
```xquery
$mode as  xs:string
```

### <a name="var_LOG-LEVEL"/> $LOG-LEVEL
```xquery
$LOG-LEVEL as  xs:string
```

### <a name="var_log-flag"/> $log-flag
```xquery
$log-flag as  xs:boolean
```

### <a name="var_assert"/> $assert
```xquery
$assert as  xs:boolean
```

### <a name="var_flush-flag"/> $flush-flag
```xquery
$flush-flag as  xs:boolean
```

### <a name="var_debug-flag"/> $debug-flag
```xquery
$debug-flag as  xs:boolean
```

### <a name="var_profile-flag"/> $profile-flag
```xquery
$profile-flag as  xs:boolean
```

### <a name="var_doc-flag"/> $doc-flag
```xquery
$doc-flag as  xs:boolean
```

### <a name="var_cache-flag"/> $cache-flag
```xquery
$cache-flag as  xs:boolean
```

### <a name="var_handle-response"/> $handle-response
```xquery
$handle-response as 
```

### <a name="var_dispatch"/> $dispatch
```xquery
$dispatch as 
```

### <a name="var_memoize"/> $memoize
```xquery
$memoize as 
```

### <a name="var_mustache"/> $mustache
```xquery
$mustache as 
```

### <a name="var_xmlToJSON"/> $xmlToJSON
```xquery
$xmlToJSON as 
```

### <a name="var_jsonToXML"/> $jsonToXML
```xquery
$jsonToXML as 
```



## Functions

### <a name="func_rewrite_2"/> rewrite\#2
```xquery
rewrite($originalURL as xs:string, $app-map as map:map
) as  xs:string
```

#### Params

* originalURL as  xs:string

* app-map as  map:map


#### Returns
*  xs:string

### <a name="func_handle-request_2"/> handle-request\#2
```xquery
handle-request($req as element(mx:request), $app-map as map:map
)
```

#### Params

* req as  element(mx:request)

* app-map as  map:map


### <a name="func_dispatch_2"/> dispatch\#2
```xquery
dispatch($req,$match
) as  item()*
```

#### Params

* req as 

* match as 


#### Returns
*  item()\*

### <a name="func_handle-response_2"/> handle-response\#2
```xquery
handle-response($content-type, $content
) as  item()*
```

#### Params

* content-type as 

* content as 


#### Returns
*  item()\*

### <a name="func_handle-error_1"/> handle-error\#1
```xquery
handle-error($req
) as  element(mx:error)
```

#### Params

* req as 


#### Returns
*  element(mx:error)

### <a name="func_handle-debug_2"/> handle-debug\#2
```xquery
handle-debug($req as element(mx:request),$app-map as map:map
) as  element(mx:debug)
```

#### Params

* req as  element(mx:request)

* app-map as  map:map


#### Returns
*  element(mx:debug)

### <a name="func_invoke_1"/> invoke\#1
```xquery
invoke($href as xs:string
)
```

#### Params

* href as  xs:string


### <a name="func_invoke_2"/> invoke\#2
```xquery
invoke($href as xs:string, $vars as item()*
)
```

#### Params

* href as  xs:string

* vars as  item()\*


### <a name="func_invoke_3"/> invoke\#3
```xquery
invoke($href as xs:string, $vars as item()*, $ns
)
```

#### Params

* href as  xs:string

* vars as  item()\*

* ns as 


### <a name="func_delete-cache_0"/> delete-cache\#0
```xquery
delete-cache(
)
```

### <a name="func_cache_0"/> cache\#0
```xquery
cache(
)
```

### <a name="func_delete-map_0"/> delete-map\#0
```xquery
delete-map(
)
```

### <a name="func_map_0"/> map\#0
```xquery
map(
)
```

### <a name="func_map_1"/> map\#1
```xquery
map($app
) as  map:map
```

#### Params

* app as 


#### Returns
*  map:map

### <a name="func_constructURL_3"/> constructURL\#3
```xquery
constructURL($urlPath as xs:string, $querystring as xs:string, $addParam as element(param)*
) as  xs:string
```

#### Params

* urlPath as  xs:string

* querystring as  xs:string

* addParam as  element(param)\*


#### Returns
*  xs:string

### <a name="func_param_1"/> param\#1
```xquery
param($name as xs:string
) as  item()*
```

#### Params

* name as  xs:string


#### Returns
*  item()\*

### <a name="func_session_1"/> session\#1
```xquery
session($name as xs:string
) as  item()*
```

#### Params

* name as  xs:string


#### Returns
*  item()\*

### <a name="func_data_1"/> data\#1
```xquery
data($path as xs:string
) as  item()*
```

#### Params

* path as  xs:string


#### Returns
*  item()\*

### <a name="func_data_2"/> data\#2
```xquery
data($path as xs:string, $params as item()*
) as  item()*
```

#### Params

* path as  xs:string

* params as  item()\*


#### Returns
*  item()\*

### <a name="func_eval_1"/> eval\#1
```xquery
eval($query as xs:string
)
```

#### Params

* query as  xs:string


### <a name="func_memoize_3"/> memoize\#3
```xquery
memoize($func,$req, $content
)
```

#### Params

* func as 

* req as 

* content as 


### <a name="func_log_1"/> log\#1
```xquery
log($message
)
```

#### Params

* message as 


### <a name="func_get-request_0"/> get-request\#0
```xquery
get-request(
) as  element(mx:request)
```

#### Returns
*  element(mx:request)





*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
