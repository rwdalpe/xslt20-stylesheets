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

  <p:pipeline type="dbp:preprocess" name="preprocess-main">
    <p:input port="original-source" primary="false" />
    <p:option name="syntax-highlighter" select="0" />
    <p:option name="preprocess-params-file" select="''" />

    <p:xinclude name="xinclude" fixup-xml-base="false"
      fixup-xml-lang="false" />

    <dbp:preprocess-parametrize name="parametrize-normalize">
      <p:input port="source">
        <p:document href="../../preprocess/50-normalize.xsl" />
      </p:input>
      <p:with-option name="params-file" select="$preprocess-params-file" />
    </dbp:preprocess-parametrize>

    <p:xslt name="logical-structure">
      <p:input port="source">
        <p:pipe step="xinclude" port="result" />
      </p:input>
      <p:input port="stylesheet">
        <p:document href="../../preprocess/00-logstruct.xsl" />
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
        <p:document href="../../preprocess/20-transclude.xsl" />
      </p:input>
      <p:input port="parameters">
        <p:empty />
      </p:input>
      <!-- <p:log port="result" href="/tmp/20-transclude.xml"/> -->
    </p:xslt>

    <p:xslt name="profile">
      <p:input port="stylesheet">
        <p:document href="../../preprocess/30-profile.xsl" />
      </p:input>
      <!-- Use the parameters passed to the pipeline -->
      <!-- <p:log port="result" href="/tmp/30-profile.xml"/> -->
    </p:xslt>

    <p:xslt name="schemaext">
      <p:input port="stylesheet">
        <p:document href="../../preprocess/40-schemaext.xsl" />
      </p:input>
      <!-- <p:log port="result" href="/tmp/40-schemaext.xml"/> -->
    </p:xslt>

    <p:choose name="verbatim">
      <p:when test="$syntax-highlighter = 0">
        <p:xslt name="run45">
          <p:input port="stylesheet">
            <p:document href="../../preprocess/45-verbatim.xsl" />
          </p:input>
          <!-- <p:log port="result" href="/tmp/45-verbatim.xml"/> -->
        </p:xslt>
      </p:when>
      <p:otherwise>
        <p:identity />
      </p:otherwise>
    </p:choose>

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
      <!-- <p:log port="result" href="/tmp/50-normalize.xml"/> -->
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
      <!-- <p:log port="result" href="/tmp/doc.xml"/> -->
    </p:xslt>
  </p:pipeline>
</p:library>