<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="template"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../../../lib/library-1.0.xpl"/>
	<p:import href="../../../lib/test.xpl"/>
	
	<p:documentation>template</p:documentation>
	
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

              &lt;tests name="test template rendering"&gt;

                &lt;test name="test xslt template"&gt;
                  &lt;expected&gt;<![CDATA[&lt;html&gt;&lt;body&gt;&lt;h2&gt;MX XSLT Template&lt;/h2&gt;&lt;textarea rows="10" cols="60"&gt;&lt;html xmlns="http://www.marklogic.com/mx"&gt;&lt;body&gt;&lt;h1&gt;MX Status Page&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:handle-response('text/xml',
          xdmp:xslt-eval(&lt;xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"&gt;
      &lt;xsl:template match="*"&gt;
        &lt;html&gt;
          &lt;body&gt;
            &lt;h2&gt;MX XSLT Template&lt;/h2&gt;
            &lt;textarea rows="10" cols="60"&gt;
            &lt;xsl:copy/&gt; test
            &lt;/textarea&gt;
          &lt;/body&gt;
        &lt;/html&gt;
      &lt;/xsl:template&gt;
    &lt;/xsl:stylesheet&gt;
, mx:data('/data.test')))}
&lt;/result&gt;
                &lt;/test&gt;

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
