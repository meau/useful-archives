<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:isbn:1-931666-22-9" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0" exclude-result-prefixes="#all">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 18, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> heberlei</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>


    <xsl:template match="@*|node()">

        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>

    </xsl:template>

    <xsl:template
        match="ead:archdesc/ead:did/ead:physdesc/ead:extent[matches(., 'linear feet\s*\S+', 'i') or 
        matches(., 'linear ft\.\s*\S+', 'i') or matches(., 'linear foot\s*\S+', 'i') or matches(., 'ln\.\s*ft\.\s*\S+', 'i')]">

        <xsl:variable name="extent-string-linear" as="xs:string">
            <xsl:value-of select="current()"/>
        </xsl:variable>
        <xsl:variable name="linear-tokens" as="xs:string">
            <xsl:analyze-string select="$extent-string-linear"
	                regex="(linear feet)|(linear ft\.)|(linear foot)|(ln\.\s*ft\.)" flags="i">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(current())"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <extent encodinganalog="300$a">
            <xsl:value-of select="normalize-space(substring-before(., $linear-tokens))"/>
            <xsl:text> linear feet</xsl:text>
        </extent>
        <extent encodinganalog="300$a">
            <xsl:value-of select="normalize-space(substring-after(., $linear-tokens))"/>
        </extent>
    </xsl:template>

    <xsl:template
        match="ead:archdesc/ead:did/ead:physdesc/ead:extent[matches(., 'cubic feet\s*\S+', 'i') or 
        matches(., 'cubic ft\.\s*\S+', 'i') or matches(., 'cubic foot\s*\S+', 'i') or matches(., 'cu\.\s*ft\.\s*\S+', 'i')]">
        <xsl:variable name="extent-string-cubic" as="xs:string">
            <xsl:value-of select="current()"/>
        </xsl:variable>
        <xsl:variable name="cubic-tokens" as="xs:string">
            <xsl:analyze-string select="$extent-string-cubic"
                regex="(cubic feet)|(cubic ft\.)|(cubic foot)|(cu\.\s*ft\.)" flags="i">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(current())"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <extent encodinganalog="300$a">
            <xsl:value-of select="normalize-space(substring-before(., $cubic-tokens))"/>
            <xsl:text> cubic feet</xsl:text>
        </extent>
        <extent encodinganalog="300$a">
            <xsl:value-of select="normalize-space(substring-after(., $cubic-tokens))"/>
        </extent>
    </xsl:template>
    
    <xsl:template
        match="ead:dsc//ead:extent[matches(., 'linear feet\s*\S+', 'i') or 
        matches(., 'linear ft\.\s*\S+', 'i') or matches(., 'linear foot\s*\S+', 'i') or matches(., 'ln\.\s*ft\.\s*\S+', 'i')]">
        
        <xsl:variable name="extent-string-linear" as="xs:string">
            <xsl:value-of select="current()"/>
        </xsl:variable>
        <xsl:variable name="linear-tokens" as="xs:string">
            <xsl:analyze-string select="$extent-string-linear"
                regex="(linear feet)|(linear ft\.)|(linear foot)|(ln\.\s*ft\.)" flags="i">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(current())"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <extent>
            <xsl:value-of select="normalize-space(substring-before(., $linear-tokens))"/>
            <xsl:text> linear feet</xsl:text>
        </extent>
        <extent>
            <xsl:value-of select="normalize-space(substring-after(., $linear-tokens))"/>
        </extent>
    </xsl:template>
    
    <xsl:template
        match="ead:dsc//ead:extent[matches(., 'cubic feet\s*\S+', 'i') or 
        matches(., 'cubic ft\.\s*\S+', 'i') or matches(., 'cubic foot\s*\S+', 'i') or matches(., 'cu\.\s*ft\.\s*\S+', 'i')]">
        <xsl:variable name="extent-string-cubic" as="xs:string">
            <xsl:value-of select="current()"/>
        </xsl:variable>
        <xsl:variable name="cubic-tokens" as="xs:string">
            <xsl:analyze-string select="$extent-string-cubic"
                regex="(cubic feet)|(cubic ft\.)|(cubic foot)|(cu\.\s*ft\.)" flags="i">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(current())"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <extent>
            <xsl:value-of select="normalize-space(substring-before(., $cubic-tokens))"/>
            <xsl:text> cubic feet</xsl:text>
        </extent>
        <extent>
            <xsl:value-of select="normalize-space(substring-after(., $cubic-tokens))"/>
        </extent>
    </xsl:template>
    
    
</xsl:stylesheet>
