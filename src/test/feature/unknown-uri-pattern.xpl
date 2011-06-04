<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:error="http://marklogic.com/xdmp/error"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="unkown-uri-pattern"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../../../lib/library-1.0.xpl"/>
	<p:import href="../../../lib/test.xpl"/>
	
	<p:documentation>Attempts to retrieve a document with an HTTP GET request for an invalid URI pattern.</p:documentation>
	
	<p:filter select="/config/connection[@protocol = 'http']"/>
	
	<test:http-request href="/foo/non-existent/path"
		accept="application/svg+xml">
		<p:with-option name="base-uri" select="concat(/connection/@protocol, '://', /connection/@host, ':', /connection/@port)"/>
		<p:with-option name="username" select="/connection/@username"/>
		<p:with-option name="password" select="/connection/@password"/>
	</test:http-request>
	
	<p:http-request/>
	
	<!--p:validate-with-schematron assert-valid="true">
		<p:input port="schema">
			<p:inline>
				<schema xmlns="http://purl.oclc.org/dsdl/schematron">
					<ns prefix="eoi"	uri="http://www.oecd.org/eoi"/>
					<ns prefix="c"		uri="http://www.w3.org/ns/xproc-step"/>
					<ns prefix="error"	uri="http://marklogic.com/xdmp/error"/>
					<pattern>
						<title>Check for a valid error response.</title>
						<rule context="/c:response">
							<assert test="@status = 400">The HTTP response of '<value-of select="@status"/>' does not match the required value of '400'.</assert>
						</rule>
						<rule context="/c:response/c:body/error:error">
							<assert test="error:name = 'err:REQ001'">The error code of <value-of select="error:name"/> does not match the required value of 'err:REQ001'.</assert>
						</rule>
					</pattern>
				</schema>
			</p:inline>
		</p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
	</p:validate-with-schematron//-->
</p:declare-step>