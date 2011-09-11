<p:declare-step 
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		name="const"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../lib/library-1.0.xpl"/>
	
	<p:documentation>test constants</p:documentation>
	
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

              declare function (:TEST:) local:loadModuleTest() { 
              test:assertStringEqual( $mx:controller-path, '/mx-controller.xqy')
              };

              &lt;tests name="check constants"&gt;
                &lt;test name="check $mx:mode"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{local:loadModuleTest()}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check $mx:controller-path"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertStringEqual( $mx:controller-path, '/mx-controller.xqy')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check $mx:default-content-type"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertStringEqual( $mx:default-content-type, 'application/xml')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check $mx:LOG-LEVEL"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertStringEqual( $mx:LOG-LEVEL, 'fine')}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check default $mx:flush-flag"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertEqual( $mx:flush-flag, fn:false())}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check default $mx:debug-flag"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertEqual( $mx:debug-flag, fn:false())}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check default $mx:profile-flag"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertEqual( $mx:profile-flag, fn:false())}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check default $mx:doc-flag"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertEqual( $mx:doc-flag, fn:false())}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check default $mx:cache-flag"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertEqual( $mx:cache-flag, fn:false())}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="check default $mx:assert"&gt;
                  &lt;expected&gt;true&lt;/expected&gt;
                  &lt;result&gt;{test:assertEqual( $mx:assert, fn:true())}&lt;/result&gt;
                &lt;/test&gt;

                &lt;test name="$mx:map should load into server-field"&gt;
                  &lt;expected&gt;{xdmp:quote(mx:map( 
&lt;app xmlns="http://www.marklogic.com/mx" xmlns:mx="http://www.marklogic.com/mx" default-context="?"&gt;
  &lt;path url="/resource/" type="passthru" description=""/&gt;
&lt;/app&gt;))}&lt;/expected&gt;
                  &lt;result&gt;{xdmp:quote(mx:map(()))}&lt;/result&gt;
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

<p:documentation>
(:
-- Local Variables:
-- compile-command: "/usr/local/bin/calabash -isource=../config.xml -oresult=../report/const.xml const.xpl"
-- End:
:)
</p:documentation>
</p:declare-step>


