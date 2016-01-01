<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:fp="http://docbook.org/xslt/ns/extension/private"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="doc fp mp xs"
                version="2.0">

  <xsl:import href="preprocess-defaultparams.xsl" />

  <xsl:include href="" id="parameter-include" />

  <xsl:output method="xml" encoding="utf-8" indent="no"
    omit-xml-declaration="yes" />

  <!--
    Most likely handles some elements of conditional text, a.k.a. profiling, as described
    by http://www.docbook.org/tdg5/en/html/ref-elements.html#common.effectivity.attributes
    and http://www.sagehill.net/docbookxsl/Profiling.html
  -->

  <xsl:template match="*">
    <xsl:variable name="suppress" as="xs:boolean*">
      <xsl:apply-templates select="@*" mode="mp:check-suppress" />
    </xsl:variable>

    <xsl:if test="empty($suppress)">
      <xsl:copy>
        <xsl:apply-templates select="@*,node()" />
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="attribute()|text()|comment()|processing-instruction()">
    <xsl:copy />
  </xsl:template>

  <!-- ============================================================ -->

  <!-- default is empty sequence = not suppressed -->
  <xsl:template match="@*" mode="mp:check-suppress" as="xs:boolean?" />

  <xsl:template match="@lang" mode="mp:check-suppress" priority="100"
    as="xs:boolean?">
    <xsl:sequence select="fp:profile-suppress(., $profile.lang, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@revisionflag" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.revisionflag, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@role" mode="mp:check-suppress" priority="100"
    as="xs:boolean?">
    <xsl:sequence select="fp:profile-suppress(., $profile.role, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@arch" mode="mp:check-suppress" priority="100"
    as="xs:boolean?">
    <xsl:sequence select="fp:profile-suppress(., $profile.arch, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@audience" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.audience, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@condition" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.condition, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@conformance" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.conformance, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@os" mode="mp:check-suppress" priority="100"
    as="xs:boolean?">
    <xsl:sequence select="fp:profile-suppress(., $profile.os, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@outputformat" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.outputformat, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@revision" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.revision, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@security" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.security, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@userlevel" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.userlevel, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@vendor" mode="mp:check-suppress" priority="100"
    as="xs:boolean?">
    <xsl:sequence select="fp:profile-suppress(., $profile.vendor, $profile.separator)" />
  </xsl:template>

  <xsl:template match="@wordsize" mode="mp:check-suppress"
    priority="100" as="xs:boolean?">
    <xsl:sequence
      select="fp:profile-suppress(., $profile.wordsize, $profile.separator)" />
  </xsl:template>

  <!-- ============================================================ -->

  <doc:function name="fp:profile-suppress" xmlns="http://docbook.org/ns/docbook"
    as="xs:boolean">
    <refpurpose>Returns true if and only iff the profile should be
      suppressed
      based on the specified attribute
    </refpurpose>

    <refdescription>
      <para>This function compares the profile values actually specified in
        an
        attribute with the set of values being used for profiling and returns
        true if the current attribute is not in the specified profile.
      </para>
    </refdescription>

    <refparameter>
      <variablelist>
        <varlistentry>
          <term>attr</term>
          <listitem>
            <para>The profiling attribute.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>prof</term>
          <listitem>
            <para>The desired profile.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>

    <refreturn>
      <para>True iff the element should be suppressed.</para>
    </refreturn>
  </doc:function>

  <xsl:function name="fp:profile-suppress" as="xs:boolean?">
    <xsl:param name="attr" as="attribute()" />
    <xsl:param name="prof" as="xs:string?" />
    <xsl:param name="profile.separator" as="xs:string" />

    <xsl:if test="exists($prof)">
      <xsl:variable name="node-values" select="tokenize($attr, $profile.separator)" />
      <xsl:variable name="profile-values" select="tokenize($prof, $profile.separator)" />
			
			<!--
			<xsl:message>
        <xsl:value-of select="$node-values" />
        <xsl:text>=</xsl:text>
        <xsl:value-of select="$profile-values" />
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$node-values = $profile-values" />
      </xsl:message>
			-->

      <!-- take advantage of existential semantics of "=" -->
      <xsl:if test="not($node-values = $profile-values)">
        <xsl:sequence select="true()" />
      </xsl:if>
    </xsl:if>
  </xsl:function>

</xsl:stylesheet>
