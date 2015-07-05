<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="l10n.gentext.default.language" select="'en'" />
  <xsl:param name="l10n.gentext.language" select="''" />
  <xsl:param name="l10n.gentext.use.xref.language" select="0" />
  <xsl:param name="l10n.locale.dir">../common/locales/</xsl:param>

  <xsl:param name="glossary.collection" select="''" />
  <xsl:param name="bibliography.collection" select="''" />
  <xsl:param name="docbook-namespace" select="'http://docbook.org/ns/docbook'" />
  <xsl:param name="glossary.sort" select="0"/>
</xsl:stylesheet>