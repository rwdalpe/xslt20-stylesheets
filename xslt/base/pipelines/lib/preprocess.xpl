<?xml version="1.0" encoding="utf-8"?>
<p:library version="1.0" xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:dbp="http://docbook.github.com/ns/pipeline" xmlns:pxp="http://exproc.org/proposed/steps"
	exclude-inline-prefixes="dbp pxp">
	<p:import href="general.xpl" />

	<p:pipeline type="dbp:preprocess-parametrize">
		<p:option name="params-file" required="true" />
		<p:xslt>
			<p:input port="stylesheet">
				<p:document href="../../preprocess/parametrize-preprocess-stylesheet.xsl" />
			</p:input>
			<p:with-param name="parameters-file" select="$params-file" />
		</p:xslt>
	</p:pipeline>

	<p:declare-step type="dbp:preprocess" name="preprocess-main">
		<p:output port="result" sequence="true" primary="true">
			<p:pipe step="custom-preprocess" port="result"/>
		</p:output>
		<p:output port="out-params" sequence="true" primary="false">
			<p:pipe step="all-parameters" port="result" />
		</p:output>
		<p:input port="source" sequence="true" primary="true" />
		<p:input port="original-source" primary="false" />
		<p:input port="parameters" kind="parameter" />
		<p:option name="preprocess-params-file" select="''" />
		<p:option name="preprocess" select="''" />

		<p:xinclude name="xinclude" fixup-xml-base="false"
			fixup-xml-lang="false" />

		<dbp:preprocess-parametrize name="parametrize-logstruct">
			<p:input port="source">
				<p:document href="../../preprocess/00-logstruct.xsl" />
			</p:input>
			<p:with-option name="params-file" select="$preprocess-params-file" />
		</dbp:preprocess-parametrize>

		<dbp:preprocess-parametrize name="parametrize-transclude">
			<p:input port="source">
				<p:document href="../../preprocess/20-transclude.xsl" />
			</p:input>
			<p:with-option name="params-file" select="$preprocess-params-file" />
		</dbp:preprocess-parametrize>

		<dbp:preprocess-parametrize name="parametrize-profile">
			<p:input port="source">
				<p:document href="../../preprocess/30-profile.xsl" />
			</p:input>
			<p:with-option name="params-file" select="$preprocess-params-file" />
		</dbp:preprocess-parametrize>

		<dbp:preprocess-parametrize name="parametrize-schemaext">
			<p:input port="source">
				<p:document href="../../preprocess/40-schemaext.xsl" />
			</p:input>
			<p:with-option name="params-file" select="$preprocess-params-file" />
		</dbp:preprocess-parametrize>

		<dbp:preprocess-parametrize name="parametrize-verbatim">
			<p:input port="source">
				<p:document href="../../preprocess/45-verbatim.xsl" />
			</p:input>
			<p:with-option name="params-file" select="$preprocess-params-file" />
		</dbp:preprocess-parametrize>

		<dbp:preprocess-parametrize name="parametrize-normalize">
			<p:input port="source">
				<p:document href="../../preprocess/50-normalize.xsl" />
			</p:input>
			<p:with-option name="params-file" select="$preprocess-params-file" />
		</dbp:preprocess-parametrize>
		
		<dbp:preprocess-parametrize name="parametrize-annotations">
			<p:input port="source">
				<p:document href="../../preprocess/60-annotations.xsl" />
			</p:input>
			<p:with-option name="params-file" select="$preprocess-params-file" />
		</dbp:preprocess-parametrize>

		<p:xslt name="logical-structure">
			<p:input port="source">
				<p:pipe step="xinclude" port="result" />
			</p:input>
			<p:input port="stylesheet">
				<p:pipe step="parametrize-logstruct" port="result" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
			<!-- <p:log port="result" href="/tmp/00-logstruct.xml"/> -->
		</p:xslt>

		<pxp:set-base-uri>
			<p:with-option name="uri" select="base-uri(/)">
				<p:pipe step="preprocess-main" port="original-source" />
			</p:with-option>
			<!-- <p:log port="result" href="/tmp/s-b-u-1.xml"/> -->
		</pxp:set-base-uri>

		<p:xslt name="transclude">
			<p:input port="stylesheet">
				<p:pipe step="parametrize-transclude" port="result" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
			<!-- <p:log port="result" href="/tmp/20-transclude.xml"/> -->
		</p:xslt>

		<p:xslt name="document-parameters">
			<p:input port="stylesheet">
				<p:inline>
					<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
													xmlns:db="http://docbook.org/ns/docbook"
													xmlns:c="http://www.w3.org/ns/xproc-step"
							exclude-result-prefixes="db"
													version="2.0">
						<xsl:template match="/">
							<c:param-set>
								<xsl:apply-templates select="//db:info/c:param"/>
							</c:param-set>
						</xsl:template>

						<xsl:template match="c:param[@name]" priority="100">
							<xsl:copy-of select="."/>
						</xsl:template>

						<xsl:template match="c:param">
							<xsl:message>
								<xsl:value-of select="base-uri(/)"/>
								<xsl:text>: document parameters must have name attributes.</xsl:text>
							</xsl:message>
						</xsl:template>

						<xsl:template match="db:para">
							<!-- nop; just make Saxon shut up about the namespaces. -->
						</xsl:template>
					</xsl:stylesheet>
				</p:inline>
			</p:input>
		</p:xslt>

		<!-- combine them with the pipeline parameters -->
		<p:parameters name="all-parameters">
			<p:input port="parameters">
				<p:pipe step="preprocess-main" port="parameters"/>
				<p:pipe step="document-parameters" port="result"/>
			</p:input>
			<!-- <p:log port="result" href="/tmp/all-params.xml"/> -->
		</p:parameters>

		<p:xslt name="profile">
			<p:input port="source">
				<p:pipe step="transclude" port="result" />
			</p:input>
			<p:input port="stylesheet">
				<p:pipe step="parametrize-profile" port="result" />
			</p:input>
			<p:input port="parameters">
				<p:pipe step="all-parameters" port="result" />
			</p:input>
			<!-- Use the parameters passed to the pipeline -->
			<!-- <p:log port="result" href="/tmp/30-profile.xml"/> -->
		</p:xslt>

		<p:xslt name="schemaext">
			<p:input port="stylesheet">
				<p:pipe step="parametrize-schemaext" port="result" />
			</p:input>
			<!-- <p:log port="result" href="/tmp/40-schemaext.xml"/> -->
		</p:xslt>

		<pxp:set-base-uri>
			<p:with-option name="uri" select="base-uri(/)">
				<p:pipe step="preprocess-main" port="original-source" />
			</p:with-option>
			<!-- <p:log port="result" href="/tmp/s-b-u-2.xml"/> -->
		</pxp:set-base-uri>

		<p:xslt name="normalize">
			<p:input port="stylesheet">
				<p:pipe step="parametrize-normalize" port="result" />
			</p:input>
			<p:input port="parameters">
				<p:pipe step="all-parameters" port="result" />
			</p:input>
			<!-- <p:log port="result" href="/tmp/50-normalize.xml"/> -->
		</p:xslt>

		<p:xslt name="fix-annotations">
			<p:input port="stylesheet">
				<p:pipe step="parametrize-annotations" port="result" />
			</p:input>
			<p:input port="parameters">
				<p:pipe step="all-parameters" port="result" />
			</p:input>
			<!-- <p:log port="result" href="/tmp/60-annotations.xml"/> -->
		</p:xslt>

		<p:xslt name="expand-linkbases">
			<p:input port="stylesheet">
				<p:document href="../../xlink/xlinklb.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
			<!-- <p:log port="result" href="/tmp/lb.xml"/> -->
		</p:xslt>

		<p:xslt name="inline-xlinks">
			<p:input port="stylesheet">
				<p:document href="../../xlink/xlinkex.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
			<!-- <p:log port="result" href="/tmp/ex.xml"/> -->
		</p:xslt>

		<!-- There used to be a step here that deleted the ghost: attributes inserted
			earlier.
			You can't do that, some of the final-pass processing, particularly for tables
			and
			verbatim environments, relies on the presence of computed ghost: attributes. -->

		<p:xslt name="preprocessed">
			<p:input port="stylesheet">
				<p:pipe step="inline-xlinks" port="result" />
			</p:input>
			<p:input port="source">
				<p:pipe step="expand-linkbases" port="result" />
			</p:input>
			<p:input port="parameters">
				<p:pipe step="all-parameters" port="result" />
			</p:input>
			<!-- <p:log port="result" href="/tmp/doc.xml"/> -->
		</p:xslt>
		
		<p:choose name="custom-preprocess">
			<p:when test="$preprocess = ''">
				<p:output port="result"/>
				<p:identity/>
			</p:when>
			<p:otherwise xmlns:exf="http://exproc.org/standard/functions">
				<p:output port="result"/>

				<p:load name="load-style">
					<p:with-option name="href" select="resolve-uri($preprocess, exf:cwd())"/>
				</p:load>

				<p:xslt>
					<p:input port="stylesheet">
						<p:pipe step="load-style" port="result"/>
					</p:input>
					<p:input port="source">
						<p:pipe step="preprocessed" port="result"/>
					</p:input>
				</p:xslt>
			</p:otherwise>
		</p:choose>
	</p:declare-step>
</p:library>