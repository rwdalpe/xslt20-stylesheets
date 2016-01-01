<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
								xmlns:db="http://docbook.org/ns/docbook"
								xmlns:dbp="http://docbook.github.com/ns/pipeline"
								xmlns:pxp="http://exproc.org/proposed/steps"
								xmlns:cx="http://xmlcalabash.com/ns/extensions"
								name="main" version="1.0"
								exclude-inline-prefixes="cx dbp pxp"
								type="dbp:docbook">
<p:input port="source" sequence="true" primary="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true" primary="true">
	<p:pipe step="process" port="result"/>
</p:output>
<p:output port="secondary" sequence="true" primary="false">
	<p:pipe step="process" port="secondary"/>
</p:output>
<p:serialization port="result" method="html" encoding="utf-8" indent="false"
								version="5"/>

<p:option name="format" select="'html'"/>
<p:option name="style" select="'docbook'"/>
<p:option name="preprocess" select="''"/>
<p:option name="postprocess" select="''"/>
<p:option name="return-secondary" select="'false'"/>
<p:option name="pdf" select="'/tmp/docbook.pdf'"/>
<p:option name="css" select="''"/>
<p:option name="initial-stylesheet" select="''" />
<p:option name="preprocess-params-file" select="''" />

<p:import href="lib/general.xpl" />
<p:import href="lib/preprocess.xpl" />
<p:import href="db-xhtml.xpl"/>
<p:import href="db-cssprint.xpl"/>
<p:import href="db-foprint.xpl"/>

<dbp:preprocess name="preprocessed">
	<p:output port="result" sequence="true" primary="true" />
	<p:output port="out-params" sequence="true" primary="false" />
	<p:input port="original-source">
		<p:pipe step="main" port="source" />
	</p:input>
	<p:input port="parameters">
		<p:pipe step="main" port="parameters" />
	</p:input>
	<p:with-option name="preprocess" select="$preprocess" />
	<p:with-option name="preprocess-params-file" select="$preprocess-params-file" />
</dbp:preprocess>

<p:choose name="process">
	<p:when test="$format = 'xhtml' or $format = 'html'">
		<p:output port="result" sequence="true" primary="true"/>
		<p:output port="secondary" sequence="true" primary="false">
			<p:pipe step="html" port="secondary"/>
		</p:output>
		<dbp:docbook-xhtml name="html">
			<p:input port="parameters">
				<p:pipe step="preprocessed" port="out-params"/>
			</p:input>
			<p:with-option name="style" select="$style"/>
			<p:with-option name="format" select="$format"/>
			<p:with-option name="postprocess" select="$postprocess"/>
			<p:with-option name="return-secondary" select="$return-secondary"/>
			<p:with-option name="initial-stylesheet" select="$initial-stylesheet"/>
		</dbp:docbook-xhtml>
	</p:when>

	<p:when test="$format = 'cssprint' or $format = 'css' or $format = 'print'">
		<p:output port="result" sequence="true" primary="true"/>
		<p:output port="secondary" sequence="true" primary="false">
			<p:pipe step="css" port="secondary"/>
		</p:output>
		<dbp:docbook-css-print name="css">
			<p:input port="parameters">
				<p:pipe step="preprocessed" port="out-params"/>
			</p:input>
			<p:with-option name="style" select="$style"/>
			<p:with-option name="postprocess" select="$postprocess"/>
			<p:with-option name="pdf" select="$pdf"/>
			<p:with-option name="css" select="$css"/>
			<p:with-option name="initial-stylesheet" select="$initial-stylesheet"/>
		</dbp:docbook-css-print>
	</p:when>

	<p:when test="$format = 'foprint' or $format='fo'">
		<p:output port="result" sequence="true" primary="true"/>
		<p:output port="secondary" sequence="true" primary="false">
			<p:pipe step="fo" port="secondary"/>
		</p:output>
		<dbp:docbook-fo-print name="fo">
			<p:input port="parameters">
				<p:pipe step="preprocessed" port="out-params"/>
			</p:input>
			<p:with-option name="format" select="$format"/>
			<p:with-option name="style" select="$style"/>
			<p:with-option name="postprocess" select="$postprocess"/>
			<p:with-option name="pdf" select="$pdf"/>
			<p:with-option name="initial-stylesheet" select="$initial-stylesheet"/>
		</dbp:docbook-fo-print>
	</p:when>

	<p:otherwise>
		<p:output port="result" sequence="true" primary="true"/>
		<p:output port="secondary" sequence="true" primary="false">
			<p:empty/>
		</p:output>
		<p:identity>
			<p:input port="source">
				<p:inline><err>Error. Bad format requested.</err></p:inline>
			</p:input>
		</p:identity>
	</p:otherwise>
</p:choose>
</p:declare-step>
