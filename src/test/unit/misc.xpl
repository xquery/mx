<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="misc"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../lib/library-1.0.xpl"/>
	
	<p:documentation>misc</p:documentation>
	
	<p:filter select="/config/connection[@protocol = 'xdbc']"/>

	<ml:adhoc-query name="retrieve"> 
        <p:input port="source">
          <p:inline>
            <query>
              xquery version "1.0";

              import module namespace test = "http://www.marklogic.com/test"
              at "/lib/test.xqm";

              import module namespace mx = "http://www.marklogic.com/mx" at 
              "/lib/mx.xqm";

              declare namespace xdmp = "http://marklogic.com/xdmp";

              declare variable $mx:app := mx:map( xdmp:document-get('/Users/jfuller/Source/Webcomposite/mx/src/test-app/app.xml'));

              &lt;tests name="test misc mx functions"&gt;

                &lt;test name="test mx:eval with /data.test"&gt;
                  &lt;expected&gt;<![CDATA[<data xmlns="http://www.marklogic.com/mx"><test><a>2</a></test></data>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:eval("mx:data('/data.test')")}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx:data with /mx"&gt;
                  &lt;expected&gt;<![CDATA[<html xmlns="http://www.marklogic.com/mx"><body><h1>MX Status Page</h1></body></html>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:data("/mx")}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx:data 2 with /data.test"&gt;
                  &lt;expected&gt;<![CDATA[<data xmlns="http://www.marklogic.com/mx"><test><a>2</a></test></data>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:data("/data.test")}&lt;/result&gt;
                &lt;/test&gt;

<!--

                &lt;test name="test mx:param "&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertStringContain(mx:param("dt"),':')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx:get-request "&gt;
                  &lt;expected&gt;<![CDATA[<mx:request
                  xmlns:mx="http://www.marklogic.com/mx" method=""
                  rewrite-url="" protocol="xdbc"
                  client-ip="127.0.0.1"><session-fields/><headers/><params></params><files/><body
                  content-type=""/></mx:request>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:get-request()}&lt;/result&gt;
                &lt;/test&gt;
//-->
              &lt;/tests&gt;

            </query>
          </p:inline>
        </p:input>
	<p:input port="parameters">
	  <p:empty/>
	</p:input>
	<p:with-option name="host" select="/connection/@host"/>
	<p:with-option name="port" select="/connection/@port"/>
	<p:with-option name="user" select="/connection/@username"/>
	<p:with-option name="password" select="/connection/@password"/>
	<p:with-option name="content-base" select="//*"/>
	</ml:adhoc-query>
	
</p:declare-step>
