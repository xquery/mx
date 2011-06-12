<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="module"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../../../lib/library-1.0.xpl"/>
	<p:import href="../../../lib/test.xpl"/>
	
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

              &lt;tests name="test module invokation and loading"&gt;

                &lt;test name="test mx:invoke with /module/example.xqy"&gt;
                  &lt;expected&gt;<![CDATA[<test>2</test>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:invoke("/modules/example.xqy")}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx:invoke via mx:eval with /module/example.xqy"&gt;
                  &lt;expected&gt;<![CDATA[<test>2</test>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:eval(mx:invoke("/modules/example.xqy"))}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test module access via mx:data with /xquery.test"&gt;
                  &lt;expected&gt;<![CDATA[<test>2</test>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:data('/xquery.test')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx:invoke with /module/example-module.xqm"&gt;
                  &lt;expected&gt;<![CDATA[<test>test</test>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:invoke("/modules/example-module.xqm#my:test",'test','http://example.org/test')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx:invoke 2 with /module/example-module.xqm"&gt;
                  &lt;expected&gt;<![CDATA[<test>dynamic</test>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:invoke("/modules/example-module.xqm#my:test",'dynamic','http://example.org/test')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="test mx:invoke with arity 2 function in /module/example-module.xqm "&gt;
                  &lt;expected&gt;<![CDATA[<test>hello world</test>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:invoke("/modules/example-module.xqm#my:test2",('hello','world'),'http://example.org/test')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="another test mx:invoke with arity 2 function in /module/example-module.xqm "&gt;
                  &lt;expected&gt;<![CDATA[<test>world hello</test>]]>&lt;/expected&gt;
                  &lt;result&gt;{mx:invoke("/modules/example-module.xqm#my:test2",('world','hello'),'http://example.org/test')}&lt;/result&gt;
                &lt;/test&gt;

                <!--
                    passing xquery params 
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
