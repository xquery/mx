<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="invoke-module"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../../../lib/library-1.0.xpl"/>
	<p:import href="../../../lib/test.xpl"/>
	
	<p:documentation>directly invoke fx-controller.xqy module</p:documentation>
	
	<p:filter select="/config/connection[@protocol = 'xdbc']"/>
	
	<ml:invoke-module name="retrieve" 
			module="/mx-controller.xqy">
      <p:with-param name="mode" select="'rewrite'" port="parameters"/>
      <p:with-option name="host" select="/connection/@host"/>
      <p:with-option name="port" select="/connection/@port"/>
      <p:with-option name="user" select="/connection/@username"/>
      <p:with-option name="password" select="/connection/@password"/>
	</ml:invoke-module>

    <p:xslt>
      <p:input port="stylesheet">
        <p:inline>
          <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              version="2.0">
            <xsl:template match="/">
              <tests name="invoke module">
                <test name="invoke main controller module">
                  <expected>/mx-controller.xqy?mode=error&amp;</expected>
                  <result><xsl:copy-of select="*/text()"/></result>
                </test>
              </tests>
            </xsl:template>
          </xsl:stylesheet>
        </p:inline>
      </p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>

    </p:xslt>

	<!--p:validate-with-schematron assert-valid="true" xmlns:c="http://www.w3.org/ns/xproc-step"> 
		<p:input port="schema">
			<p:inline xmlns:c="http://www.w3.org/ns/xproc-step">
				<schema xmlns="http://purl.oclc.org/dsdl/schematron">
					<ns prefix="xhtml"	uri="http://www.w3.org/1999/xhtml" xmlns:c="http://www.w3.org/ns/xproc-step"/>
					<pattern>
						<title>Check for a valid response.</title>
						<rule context="/" xmlns:c="http://www.w3.org/ns/xproc-step">
							<assert test="*:result" xmlns:c="http://www.w3.org/ns/xproc-step">There must be an :div document element.</assert>
						</rule>
					</pattern>
				</schema>
			</p:inline>
		</p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
	</p:validate-with-schematron-->
</p:declare-step>