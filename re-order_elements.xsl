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


    <xsl:template match="@*|node()|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:eadheader">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:eadid"/>
            <xsl:apply-templates select="ead:filedesc"/>
            <xsl:apply-templates select="ead:profiledesc"/>
            <xsl:apply-templates select="ead:revisiondesc"/>
            <xsl:apply-templates select="*[not(self::ead:eadid|self::ead:filedesc|self::ead:profiledesc|self::ead:revisiondesc)]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:archdesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:did"/>
            <xsl:apply-templates select="ead:bioghist"/>
            <xsl:apply-templates select="ead:descgrp[@id='dacs3']"/>
            <xsl:apply-templates select="ead:descgrp[@id='dacs4']"/>
            <xsl:apply-templates select="ead:descgrp[@id='dacs5']"/>
            <xsl:apply-templates select="ead:descgrp[@id='dacs6']"/>
            <xsl:apply-templates select="ead:descgrp[@id='dacs7']"/>
            <xsl:apply-templates select="ead:dao"/>
            <xsl:apply-templates select="ead:controlaccess"/>
            <xsl:apply-templates select="ead:dsc"/>
            <xsl:apply-templates select="*[not(self::ead:did|self::ead:bioghist|self::ead:descgrp|self::ead:dao|self::ead:controlaccess|self::ead:dsc)]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:archdesc/ead:did">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:unitid"/>
            <xsl:apply-templates select="ead:repository"/>
            <xsl:apply-templates select="ead:unittitle"/>
            <xsl:apply-templates select="ead:unitdate"/>
            <xsl:apply-templates select="ead:physdesc"/>
            <xsl:apply-templates select="ead:origination"/>
            <xsl:apply-templates select="ead:langmaterial"/>
            <xsl:apply-templates select="ead:abstract"/>
            <xsl:apply-templates select="ead:physloc"/>
            <xsl:apply-templates select="*[not(self::ead:unitid|self::ead:repository|self::ead:unittitle|self::ead:unitdate|self::ead:physdesc|self::ead:origination|self::ead:langmaterial|self::ead:abstract|self::ead:physloc)]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:descgrp[@id='dacs3']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:scopecontent"/>
            <xsl:apply-templates select="ead:arrangement"/>
            <xsl:apply-templates select="*[not(self::ead:scopecontent|self::ead:arrangement)]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:descgrp[@id='dacs4']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:accessrestrict"/>
            <xsl:apply-templates select="ead:phystech"/>
            <xsl:apply-templates select="ead:userestrict"/>
            <xsl:apply-templates select="ead:otherfindaid"/>
            <xsl:apply-templates select="*[not(self::ead:accessrestrict|self::ead:phystech|self::ead:userestrict|self::ead:otherfinaid)]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:descgrp[@id='dacs5']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:custodhist"/>
            <xsl:apply-templates select="ead:acqinfo"/>
            <xsl:apply-templates select="ead:appraisal"/>
            <xsl:apply-templates select="ead:accruals"/>
            <xsl:apply-templates select="*[not(self::ead:custodhist|self::ead:acqinfo|self::ead:appraisal|self::ead:accruals)]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:descgrp[@id='dacs6']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:originalsloc"/>
            <xsl:apply-templates select="ead:altformavail"/>
            <xsl:apply-templates select="ead:relatedmaterial"/>
            <xsl:apply-templates select="ead:bibliography"/>
            <xsl:apply-templates select="*[not(self::ead:originalsloc|self::ead:altformavail|self::ead:relatedmaterial|self::ead:bibliography)]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:descgrp[@id='dacs7']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead:note"/>
            <xsl:apply-templates select="ead:prefercite"/>
            <xsl:apply-templates select="ead:processinfo"/>
            <xsl:apply-templates select="ead:bibliography"/>
            <xsl:apply-templates select="*[not(self::ead:note|self::ead:prefercite|self::ead:processinfo|self::ead:bibliography)]"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
