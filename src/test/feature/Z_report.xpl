<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic" 
		xmlns:test="http://www.marklogic.com/test"
		name="feature-report"
		version="1.0"
		exclude-inline-prefixes="c ml p">
	
	<p:input port="source"/>
	<p:output port="result"/>
	
	<p:import href="../../../lib/library-1.0.xpl"/>
	<p:import href="../../../lib/test.xpl"/>
	
	<p:documentation>generate feature report</p:documentation>

	<p:directory-list path="../../../report/feature" include-filter=".*\.xml"/>
	
	<p:for-each name="iterate">
		<p:iteration-source select="/c:directory/c:*"/>
        <p:load> 
          <p:with-option name="href" select="concat('../../../report/feature/',c:file/@name)"/>
        </p:load>   
    </p:for-each>		
    <p:wrap-sequence wrapper="results"/>

    <p:xslt>
      <p:with-param name="title" select="'MX Feature Test'" port="parameters"/>
      <p:input port="stylesheet">
        <p:document href="../feature-report.xsl"/>
      </p:input>
    </p:xslt>

</p:declare-step>
