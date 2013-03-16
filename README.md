#IMPORTANT (mx is deprecated)

Goto [[RXQ - RESTXQ Annotations for building RESTful web applications][https://github.com/xquery/rxq]

# MarkLogic XQuery framework (mx)

MX is designed to provide a 'starting point' for developing MarkLogic XQuery web applications.

It is a 'work in progress' and a testbed for trying out things, so
please excuse the general unfinished state.

The principles of MX in a nutshell;

* KISS ... keep concepts simple and to a minimum, preferably one if possible
* everything has a URI
* simplify MVC by allowing everything to be a Model 
* single import
* TMTOWTDI e.g. dont constrain developer wherever possible 


## Website

'sparse' documentation and source code can always be found from the MX github repo

https://github.com/xquery/mx


## Dependency

MarkLogic server is required, please refer to MarkLogic excellent documentation for getting 
the server installed and initializing a database and related HTTP application server.

I have also bundled the excellent mustache.xq (Nuno Job / John
Snelson) to show how to define templates using it.

https://github.com/dscape/mustache.xq


## Dist

src/example-app - contains test application that uses mx.xqm

src/xquery - contains mx.xqm library and mx-controller.xqy

tests -  there are tests for mx but I have opted to not include them
in the dist for the time being

## Installation of example-app

You need to  ensure you have a MarkLogic database and application
server setup. 

Once you have a working MarkLogic HTTP application server running then;

    download mx (or get from git) distro

    edit src/example-app/mx-controller.xqy and change $mx:app to reflect your path

        declare variable $mx:app := mx:map( xdmp:document-get('/Users/jfuller/Source/Webcomposite/mx/src/example-app/app.xml'));

    to

        declare variable $mx:app := mx:map( xdmp:document-get('TO YOUR OWN PATH app.xml'));

In the ML application server set the following;

    set root to where src/example-app is located in your environment

    set url rewriter to /mx-controller.xqy?mode=rewrite

    set error handler to /mx-controller.xqy?mode=error

    you may have to set user with correct privileges depending on your
    setup

Once you have done the above you should be able to access the example-app

    ex. http://localhost:9000/mx?flush=true

## Overview

The best way to learn what MX does and how to build applications with
it is to review app.xml

*src/example-app/app.xml* - defines all routing and how data and views come
together. Note that this is loaded into an ML server field which is
why you need to use the url param flush=1 to force reload (if you add
new changes or make a change to app.xml)

*passthru* - will allow HTTP requests through

```xml
<path url="/resource/" type="passthru" description=""/>
<path url="/robots.txt" type="passthru" description=""/>
<path url="/static-test.html" type="passthru" description=""/>
<path url="/app.xml" type="passthru" description=""/>
```

*http redirection* - will either forward or redirect HTTP request

```xml
<path url="/forward.test" type="forward" description="example of forwarding">/static-test.html</path>
<path url="/redirect.test" type="redirect" description="example of
redirecting,
changing the
url">/static-test.html</path>
```

*inline tests* - Shows how to generate static content

```xml
<path url="/inline.test" method="GET">
<html>
<body>
<h1>inline test</h1>
</body>
</html>
</path>
```

*data* - how to setup models  (but remember everything is a model)

```xml
<path url="/data.test" method="GET" description="inline test with no content type set, should fall back to using application/xml">
<data title="this is /data.test">
<test>
<a>{1 + 1}</a>
</test>
</data>
</path>
```

*module* - how to invoke xquery modules

```xml
<path url="/xquery.test" method="GET" href="/modules/example.xqy"/>
```


*templates* - create templates which reuse data

```xml
<path url="/template1" type="template" method="GET"
content-type="text/html" data="/data7.test"
description="create template with mustache">
<html>
<head>
</head>
<body>
Hello {{text}}!
</body>
</html>
</path>
```

*json* - there are some experiemental json stuff as well


## Using in your own XQuery Applications

At a minimum you need 3 things;

* mx.xqm - single module for mx
* mx-controller.xqy - just edit path
* app.xml - application specific

I have tried not to make too much 'ceremony' e.g. its left to you how
you want to do things.

Obviously you will need to edit app.xml, but you are free to setup
however way you want your modules, templates, etc.


## URL Params

appending the following url params to any url 

* debug=true   - will display underlying XML and HTTP Request
  information

```
http://localhost:9000/inline.test?debug=true
```

* profile=true - will enable profiling information to be included in
  debug 

```
http://localhost:9000/inline.test?profile=true&debug=true
```

* flush=true   - will force app.xml to reload into server field which
  is required anytime you edit app.xml.

```
http://localhost:9000/inline.test?flush=true
```

* cache=true   - will enable inline function caching

```
http://localhost:9000/inline.test?cache=true
```



## Tests

Tests for mx are written in xproc contained under src/test/unit. To
run tests you must setup an XDBC application server in ML and set
configuration within src/test/config.xml

<config>
	<connection protocol="http" host="localhost" port="9002" username="test" password="test"/>
	<connection protocol="xdbc" host="localhost" port="9001" username="test" password="test"/>
</config>

You will also require installing Norman Walsh's implementation of
XProc XMLCalabash.

To run tests review runner scripts under src/test/bin

## Resources

MX github: http://www.github.com/xquery/mx

XSGI: previous experiment for use with eXist XML Database (http://code.google.com/p/xsgi/)

Martin Fowler's Harvested Frameworks does a good job at capturing how MX was developed.


## Acknowledgements


Many of the principles embedded in MX were inspired by active/passive
observations and conversations with some of my MarkLogic colleagues;

Alex Bleasdale, Micah Dubinko, Philip Fennel, Nuno Job, Justin Makeig,
Olav Schrewing, Pete Aven, Norman Walsh

Though of course, I take all the blame for anything incorrect, broken or plain stupid.


## Contact

jim.fuller@webcomposite.com
