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

              declare variable $mx:app := mx:map( xdmp:document-get('/Users/jfuller/Source/Webcomposite/mx/src/test-app/app.xml'));

              &lt;tests name="test rewrite functionality"&gt;

                &lt;test name="inline rewrite test response"&gt;
                  &lt;expected&gt;<![CDATA[/mx-controller.xqy?mode=handler&amp;url=%2Finline.test&amp;href=&amp;ns=&amp;type=&amp;model=&amp;content-type=&amp;method=GET]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/inline.test', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="forward rewrite test response"&gt;
                  &lt;expected&gt;<![CDATA[/static-test.html]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/forward.test', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="redirect rewrite test response"&gt;
                  &lt;expected&gt;<![CDATA[/mx-controller.xqy?mode=redirect&amp;type=redirect&amp;url=%2Fstatic-test.html]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/redirect.test', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="redirect rewrite test response with url params"&gt;
                  &lt;expected&gt;<![CDATA[/mx-controller.xqy?test=1&amp;mode=redirect&amp;type=redirect&amp;url=%2Fstatic-test.html]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/redirect.test?test=1', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="passthru rewrite test response"&gt;
                  &lt;expected&gt;<![CDATA[/robots.txt]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/robots.txt', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx rewrite status response"&gt;
                  &lt;expected&gt;<![CDATA[/mx-controller.xqy?mode=handler&amp;url=%2Fmx&amp;href=&amp;ns=&amp;type=inline&amp;model=&amp;content-type=text%2Fhtml&amp;method=GET]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:rewrite( '/mx', $mx:app ))}&lt;/result&gt;
                &lt;/test&gt;

<!--
                &lt;test name="test rewrite with no  param to url"&gt;
                  &lt;expected&gt;<![CDATA[/mx]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:constructURL( '/mx', '',
                  ()))}&lt;/result&gt;
                &lt;/test&gt;
//-->

                &lt;test name="test rewrite adding param to url"&gt;
                  &lt;expected&gt;<![CDATA[/mx?test=1]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:constructURL( '/mx', '',
                  &lt;param name="test" value="1"/&gt;))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test rewrite adding multiple params to url"&gt;
                  &lt;expected&gt;<![CDATA[/mx?test=1&amp;anothertest=1]]>&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:constructURL( '/mx', '',
                  (&lt;param name="test" value="1"/&gt;,&lt;param name="anothertest" value="1"/&gt;)))}&lt;/result&gt;
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
