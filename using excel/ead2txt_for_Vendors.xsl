<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:isbn:1-931666-22-9" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ns2="http://www.w3.org/1999/xlink"
    version="2.0" exclude-result-prefixes="#all">
    <!-- NOTE: output method is 'text' -->
    <xsl:output method="text" indent="yes"/>
    <!-- generate TSV file: @id on C's; container @type=box; container@type=folder; unittitle; unitdate; -->
    <!-- &#9; is TAB (replace with ',' for CSV)
         &#13; is CR (carriage return)
         NOTE that the | are just to test output
         Adjust as needed
         Save as .txt, import into Excel. -->
    <xsl:template match="/">
        <xsl:apply-templates /> 
    </xsl:template>
  <xsl:template match="*">
      <xsl:for-each select="//ead:did/parent::*">
         <!-- start demo -->
          <xsl:value-of select="name()"/>
          <xsl:text>&#9;|</xsl:text>
          <!-- this is for reassurance and testing with newer files without c0x -->
          <xsl:value-of select="concat(name(),'0',count(./ancestor-or-self::ead:c))"/>
          <xsl:text>&#9;|</xsl:text>
          <!-- end demo -->
          <xsl:value-of select="@id"/>
          <xsl:text>&#9;|</xsl:text>
          <xsl:value-of select="normalize-space(ead:did/ead:unitid)" />
          <xsl:text>&#9;|</xsl:text>
          <xsl:value-of select="ead:did/ead:container [@type='box']/@type"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="ead:did/ead:container [@type='box']"></xsl:value-of>
          <xsl:text>&#9;|</xsl:text>
          <xsl:value-of select="ead:did/ead:container[@type='folder']/@type" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="ead:did/ead:container[@type='folder']"></xsl:value-of>
          <xsl:text>&#9;|</xsl:text>
          <xsl:value-of select="ead:did/ead:container[@type='reel']/@type" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="ead:did/ead:container[@type='reel']"></xsl:value-of>
          <xsl:text>&#9;|</xsl:text>
          <xsl:value-of select="normalize-space(ead:did/ead:unittitle)" />
          <xsl:text>&#9;|</xsl:text>
<!--      <xsl:value-of select="normalize-space(ead:accessrestrict/ead:p[1])" />
          <xsl:text>|&#13;</xsl:text>-->
          <xsl:value-of select="ead:did/ead:unitdate" />
          <xsl:text>&#9;|</xsl:text>
          <xsl:value-of select="ead:did/ead:unitdate/@normal" />
          <xsl:text>|&#13;</xsl:text>
      </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
