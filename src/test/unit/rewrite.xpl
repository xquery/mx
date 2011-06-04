<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="rewrite"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../../../lib/library-1.0.xpl"/>
	<p:import href="../../../lib/test.xpl"/>
	
	<p:documentation>test rewrite</p:documentation>
	
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

              declare variable $mx:app := mx:map( xdmp:document-get('/Users/jfuller/Source/Marklogic/framework-dist/src/test-app/app.xml'));

              &lt;tests name="test rewrite functionality"&gt;

                &lt;test name="inline test response"&gt;
                  &lt;expected&gt;<![CDATA[/mx-controller.xqy?mode=handler&amp;url=/inline.test&amp;content-type=text/html&amp;type=&amp;model=&amp;method=GET&amp;]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/inline.test', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="forward test response"&gt;
                  &lt;expected&gt;<![CDATA[/static-test.html]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/forward.test', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="redirect test response"&gt;
                  &lt;expected&gt;<![CDATA[/mx-controller.xqy?mode=redirect&amp;url=/static-test.html]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/redirect.test', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="passthru test response"&gt;
                  &lt;expected&gt;<![CDATA[/robots.txt]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/robots.txt', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx status response"&gt;
                  &lt;expected&gt;<![CDATA[/mx-controller.xqy?mode=handler&amp;url=/mx&amp;content-type=&amp;type=&amp;model=&amp;method=GET&amp;]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/mx', $mx:app ))}&lt;/result&gt;
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