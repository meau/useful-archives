<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:isbn:1-931666-22-9" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ns2="http://www.w3.org/1999/xlink"
    version="2.0" exclude-result-prefixes="#all">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 18, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> heberlei</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

<!-- This mostly works with the line breaks and whitespaces, but not perfectly.
Recommend removing all line breaks and whitespace before running this.
-->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- 1.
        exactly one unitdate positioned at the end of unittitle 
        and containing text other than space. -->

    <xsl:template match="ead:unittitle[count(ead:unitdate)=1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title) and ead:unitdate[not(following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title)]]">
        <xsl:copy>
        <xsl:copy-of select="current()/(text()|ead:emph|ead:title)"/>
        </xsl:copy>    
            <xsl:copy-of select="ead:unitdate"/>        
    </xsl:template>
    
    <!--2.
        unittitle contains text,
        contains one unitdate,
        there is text after unitdate-->
    
  
    <xsl:template match="ead:unittitle[count(ead:unitdate)=1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title) and ead:unitdate[following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title]]">
<xsl:copy>
<xsl:apply-templates select="current()/(text()|ead:emph|ead:title|ead:unitdate/text())"/>
</xsl:copy>
<xsl:copy-of select="ead:unitdate"/>
</xsl:template>
    
    <!--Didn't use this bit here in the end, but it may come in useful later...  
    <xsl:template match="text()[parent::ead:unittitle[count(ead:unitdate)=1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title) and ead:unitdate[following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title]]]">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="ead:emph[parent::ead:unittitle[count(ead:unitdate)=1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title) and ead:unitdate[following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title]]]">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="ead:title[parent::ead:unittitle[count(ead:unitdate)=1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title) and ead:unitdate[following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title]]]">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="ead:unitdate[parent::ead:unittitle[count(ead:unitdate)=1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title) and ead:unitdate[following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title]]]">
        <xsl:value-of select="."/>
    </xsl:template>-->

    <!--3.
        unittitle contains multiple unitdates,
        contains text other than space and punctuation,
        there is text after last unitdate-->
    
    <xsl:template match="ead:unittitle[count(ead:unitdate)>1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title) and ead:unitdate[position()=last()][following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title]]">
    <xsl:copy>
    <xsl:apply-templates select="current()/(text()|ead:emph|ead:title|ead:unitdate/text())"/>
    </xsl:copy>
    <xsl:copy-of select="ead:unitdate"/>
    </xsl:template>

    <!-- 4. 
    unittitle contains text other than space or punctuation,
    contains multiple unitdates,
    last unitdate ends unittitle,
    all unitdates other than last are followed by space or punctuation (no other text, i.e. all unitdates are at end of unittitle)
    -->

    <xsl:template
        match="ead:unittitle[count(ead:unitdate)>1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:title or ead:emph) and ead:unitdate[position()=last()][not(following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title)] and ead:unitdate[position()!=last()][following-sibling::text()[matches(., '^[\p{Z}\p{P}]*$')]] and not(ead:unitdate[position()!=last()][following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))]])]">
          <xsl:copy>
        <xsl:copy-of select="current()/(text()|ead:emph|ead:title)"/>
        </xsl:copy>    
        <xsl:copy-of select="ead:unitdate"/>    
    </xsl:template>
    
    <!-- 5. 
        unittitle contains text other than space or punctuation,
        contains multiple unitdates,
        last unitdate ends unittitle,
        some other unitdates are followed by text        
    -->
    
    <xsl:template
        match="ead:unittitle[count(ead:unitdate)>1 and (text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:title or ead:emph) and ead:unitdate[position()=last()][not(following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or following-sibling::ead:emph or following-sibling::ead:title)] and ead:unitdate[position()!=last()][following-sibling::text()[not(matches(., '^[\p{Z}\p{P}]*$'))]]]">
        <xsl:copy>
            <xsl:apply-templates select="current()/(text()|ead:emph|ead:title|ead:unitdate/text())"/>
        </xsl:copy>
        <xsl:copy-of select="ead:unitdate"/>
    </xsl:template>
    
    <!-- 6.
        Find any unitdates nested in unittitle where the following is true:
        unittitle contains one or more unitdates,
        does not contain text other than space or comma
    -->
    
    <xsl:template
        match="ead:unittitle[count(ead:unitdate)>=1 and not((text()[not(matches(., '^[\p{Z}\p{P}]*$'))] or ead:emph or ead:title))]">
        <xsl:copy>
            <xsl:apply-templates select="current()/(text()|ead:emph|ead:title|ead:unitdate/text())"/>
        </xsl:copy>
        <xsl:copy-of select="ead:unitdate"/>
    </xsl:template>
    

</xsl:stylesheet>
