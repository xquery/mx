# MarkLogic XQuery framework (mx)

MX is designed to provide a 'starting point' for developing MarkLogic XQuery web applications.

It is a 'work in progress' and a testbed for trying out things, so
please excuse the unfinished touches.

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


        src/test-app - contains test application that uses mx.xqm

        src/xquery - contains mx.xqm library and mx-controller.xqy


## Installation of test-app


You need to  ensure you have a MarkLogic database and application
server setup. 

Once you have a working MarkLogic HTTP application server running then;

    download mx (or get from git) distro

    edit /mx-controller.xqy and change $mx:app to reflect your path

        declare variable $mx:app := mx:map( xdmp:document-get('/Users/jfuller/Source/Webcomposite/mx/src/test-app/app.xml'));

    to

        declare variable $mx:app := mx:map( xdmp:document-get('TO YOUR OWN PATH app.xml'));


In application server;

    set root to where src/test-app is located 

    set url rewriter to /mx-controller.xqy?mode=rewrite

    set error handler to /mx-controller.xqy?mode=error

    ensure /lib/mx.xqm is in lib directory of test-app (its symlinked
    from src/xquery/mx.xqm)

Once you have done the above you should be able to access the test-app

    ex. http://localhost:9000/mx?flush=true

review src/test-app/app.xml


## Overview


src/test-app/app.xml - defines all routing and how data and views come
together. Note that this is loaded into an ML server field which is
why you need to use the url param flush=1 to force reload (if you add
new changes or make a change to app.xml)

The best way to learn what MX does and how to build applications with
it is to review app.xml

  * passthru - will allow HTTP requests through
  * http redirection - will either forward or redirect HTTP request
  * inline tests - Shows how to 
  * data - how to setup models 
  * module - how to invoke xquery modules
  * example templates (views) -

          /template1 - shows how to use mustache.xq and data model (/data7.test)
          /template2 - shows how to use xslt template
          /template3 - shows how to use xquery module to supply data to xslt transformation
  * json - there are some experiemental json stuff as well


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

          debug=true - will display underlying XML and HTTP Request information

          flush=true - will force app.xml to reload into server field


## Resources


        MX github: http://www.github.com/xquery/mx

        XSGI: previous experiment for use with eXist XML Database (http://code.google.com/p/xsgi/)

        Martin Fowler's Harvested Frameworks does a good job at capturing how MX was developed.


## Acknowledgements


Many of the principles embedded in MX were inspired by active/passive
observations and conversations with some of my MarkLogic colleagues;

Alex Beasdale
,Micah Dubinko
,Philip Fennel
,Nuno Job
,Justin Makeig
,Olav Schrewing
,Pete Aven
,Norman Walsh

Though of course, I take all the blame for anything incorrect, broken or plain stupid.


## Contact

jim.fuller@webcomposite.com
