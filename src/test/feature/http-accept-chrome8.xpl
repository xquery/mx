<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="http-accept-chrome8"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../../../lib/library-1.0.xpl"/>
	<p:import href="../../../lib/test.xpl"/>
	
	<p:documentation>Send an HTTP request with Chrome 8 Accept header.</p:documentation>
	
	<p:filter select="/config/connection[@protocol = 'http']"/>
	<!-- override-content-type="text/html" -->
	<test:http-request href="/" accept="application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"
			override-content-type="text/html">
		<p:with-option name="base-uri" select="concat(/connection/@protocol, '://', /connection/@host, ':', /connection/@port)"/>
		<p:with-option name="username" select="/connection/@username"/>
		<p:with-option name="password" select="/connection/@password"/>
	</test:http-request>
	
	<test:http-response/>
	
	<p:validate-with-schematron assert-valid="true">
		<p:input port="schema">
			<p:inline>
				<schema xmlns="http://purl.oclc.org/dsdl/schematron">
					<ns prefix="c"		uri="http://www.w3.org/ns/xproc-step"/>
					<ns prefix="error"	uri="http://marklogic.com/xdmp/error"/>
					<ns prefix="xhtml"	uri="http://www.w3.org/1999/xhtml"/>
					<pattern>
						<title>Check for a valid response.</title>
						<rule context="/c:response">
							<assert test="@status = '210'">The HTTP response of '<value-of select="@status"/>' does not match the required value of '200'.</assert>
							<assert test="starts-with(c:header[@name = 'Content-Type']/@value, 'text/xml')">The response content type must be 'text/html'.</assert>
						</rule>
					</pattern>
				</schema>
			</p:inline>
		</p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
	</p:validate-with-schematron>

</p:declare-step>
