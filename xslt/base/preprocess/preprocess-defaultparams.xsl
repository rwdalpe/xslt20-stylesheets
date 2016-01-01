<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Separator for auto generated prefixes -->
  <xsl:param name="psep" select="'---'" />

  <xsl:param name="profile.separator" select="';'" />
  <xsl:param name="profile.lang" select="()" />
  <xsl:param name="profile.revisionflag" select="()" />
  <xsl:param name="profile.role" select="()" />
  <xsl:param name="profile.arch" select="()" />
  <xsl:param name="profile.audience" select="()" />
  <xsl:param name="profile.condition" select="()" />
  <xsl:param name="profile.conformance" select="()" />
  <xsl:param name="profile.os" select="()" />
  <xsl:param name="profile.outputformat" select="()" />
  <xsl:param name="profile.revision" select="()" />
  <xsl:param name="profile.security" select="()" />
  <xsl:param name="profile.userlevel" select="()" />
  <xsl:param name="profile.vendor" select="()" />
  <xsl:param name="profile.wordsize" select="()" />

  <xsl:param name="schemaext.schema" select="''" />
  <xsl:param name="schema"
    select="if ($schemaext.schema = '')
       then ()
       else document($schemaext.schema)" />
  <xsl:param name="schema-extensions" as="element()*" select="()" />

  <xsl:param name="verbatim.trim.blank.lines" select="1" />
  <xsl:param name="callout.defaultcolumn" select="60" />
  <xsl:param name="callout.unicode" select="0" />
  <xsl:param name="callout.unicode.number.limit" select="'10'" />
  <xsl:param name="callout.unicode.start.character" select="10102" />
  <xsl:param name="line-numbers" select="1" />

  <xsl:param name="l10n.gentext.default.language" select="'en'" />
  <xsl:param name="l10n.gentext.language" select="''" />
  <xsl:param name="l10n.gentext.use.xref.language" select="0" />
  <xsl:param name="l10n.locale.dir">../common/locales/</xsl:param>

  <xsl:param name="glossary.collection" select="''" />
  <xsl:param name="bibliography.collection" select="''" />
  <xsl:param name="docbook-namespace" select="'http://docbook.org/ns/docbook'" />
	<xsl:param name="unify.table.titles" select="'0'"/>
  <xsl:param name="glossary.sort" select="0" />
</xsl:stylesheet>