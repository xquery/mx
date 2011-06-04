<?xml version="1.0" encoding="UTF-8"?>
<p:library 
		xmlns:c="http://www.w3.org/ns/xproc-step" 
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:test="http://www.marklogic.com/test"
		version="1.0">
	
	<p:declare-step type="test:http-request">
		<p:documentation>Assembles an HTTP request.</p:documentation>
		<p:input port="source"/>
		<p:output port="result"/>
		
		<p:option name="base-uri"/>
		<p:option name="href"/>
		<p:option name="username"/>
		<p:option name="password"/>
		<p:option name="accept"/>
		<p:option name="method" select="'get'" required="false"/>
		<p:option name="override-content-type" select="'application/xml'" required="false"/>
		
		<p:identity>
			<p:input port="source">
				<p:inline>
					<c:request method="get" 
						auth-method="basic"
						send-authorization="true"
						override-content-type="application/xml"
						detailed="true">
						<c:header name="Accept"/>
					</c:request>
				</p:inline>
			</p:input>
		</p:identity>
		
		<p:add-attribute match="/c:request" attribute-name="href">
			<p:with-option name="attribute-value" select="concat($base-uri, $href)"/>
		</p:add-attribute>
		<p:add-attribute match="/c:request" attribute-name="method">
			<p:with-option name="attribute-value" select="$method"/>
		</p:add-attribute>
		<p:add-attribute match="/c:request" attribute-name="username">
			<p:with-option name="attribute-value" select="$username"/>
		</p:add-attribute>
		<p:add-attribute match="/c:request" attribute-name="password">
			<p:with-option name="attribute-value" select="$password"/>
		</p:add-attribute>
		<p:add-attribute match="/c:request/c:header" attribute-name="value">
			<p:with-option name="attribute-value" select="$accept"/>
		</p:add-attribute>
		<p:add-attribute match="/c:request" attribute-name="override-content-type">
			<p:with-option name="attribute-value" select="$override-content-type"/>
		</p:add-attribute>
	</p:declare-step>
	
	
	<p:declare-step type="test:http-response">
		<p:documentation>Extracts application/xhtml+xml from at text/html response.</p:documentation>
		<p:input port="source"/>
		<p:output port="result"/>
		
		<p:http-request name="response"/>
		
		<p:unescape-markup name="content" content-type="text/html">
			<p:input port="source" select="/c:response/c:body"/>
		</p:unescape-markup>
		
		<p:insert match="/c:response/c:body" position="after">
			<p:input port="source">
				<p:pipe port="result" step="response"/>
			</p:input>
			<p:input port="insertion">
				<p:pipe port="result" step="content"/>
			</p:input>
		</p:insert>
		<p:delete match="/c:response/c:body[1]"/>
	</p:declare-step>
</p:library>