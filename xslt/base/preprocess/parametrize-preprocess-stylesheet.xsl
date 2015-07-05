<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="parameters-file" select="''" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//xsl:include[@id='parameter-include']">
    <xsl:choose>
      <xsl:when test="$parameters-file != ''">
        <xsl:copy>
          <xsl:attribute name="href"><xsl:value-of select="$parameters-file" /></xsl:attribute>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>