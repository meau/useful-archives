<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ns2="http://www.w3.org/1999/xlink"
    xmlns:saxon="http://saxon.sf.net/" xmlns:functx="http://www.functx.com" xmlns:local="local.uri"
    version="2.0" exclude-result-prefixes="#all">
    <!--    <xsl:import href="sample-functions.xsl"/>-->
    <xsl:import href="http://www.xsltfunctions.com/xsl/functx-1.0-doc-2007-01.xsl"/>
    <!--<saxon:import-query href="sample-functions.xql"/>-->
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- assembly required; damage may have occurred during shipping; should just produce c elements -->
    <xsl:variable name="this-doc" select="tokenize(document-uri(.),'/')[last()]"/>
    <xsl:template match="/">
        <!--  <ead xmlns="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" audience="external"
            xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd">-->
        <root from="{$this-doc}">
            <xsl:comment>to test output of functions try this XPath on result doc: //unitdate | //unitdate/@raw</xsl:comment>
            <xsl:apply-templates/>
            <!--       <xsl:call-template name="event" /> -->
        </root>
        <!--</ead>-->
    </xsl:template>
    <xsl:template match="row">
        <c level="{level}">
            <did>
                <xsl:if test="unitid">
                    <unitid>
                        <xsl:value-of select="unitid"/>
                    </unitid>
                </xsl:if>
                <xsl:if test="unittitle">
                    <unittitle>
                        <xsl:value-of select="unittitle"/>
                    </unittitle>
                </xsl:if>
                <xsl:if test="unitdate ne ''">
                    <unitdate normal="{datenormal}">
                        <xsl:value-of select="unitdate"/> 
                    </unitdate>
                </xsl:if>
                <xsl:if test="extent">
                    <physdesc>
                        <extent>
                            <xsl:value-of select="extent"/><xsl:text> photographs</xsl:text>
                        </extent>
                    </physdesc>
                </xsl:if>
                <xsl:if test="container">
                    <container type="box">
                        <xsl:value-of select="container"/>
                    </container>
                </xsl:if>
                <xsl:if test="creator">
                    <origination>
                        <persname>
                            <xsl:value-of select="creator"/>
                        </persname>
                    </origination>
                </xsl:if>
            </did>
            <xsl:if test="scopecontent">
                <scopecontent>
                    <p>
                        <xsl:value-of select="scopecontent"/>
                    </p>
                </scopecontent>
            </xsl:if>
            <xsl:if test="arrangement">
                <arrangement>
                    <p>
                        <xsl:value-of select="arrangement"/>
                    </p>
                </arrangement>
            </xsl:if>
            <xsl:if test="subject">
                <controlaccess>
                    <subject rules="legacy" source="lcsh">
                        <xsl:value-of select="subject"/>
                    </subject>
                    <xsl:if test="genreform">
                        <genreform source="aat">
                            <xsl:value-of select="genreform"/>
                        </genreform>
                    </xsl:if>
                </controlaccess>
            </xsl:if>
            <xsl:if test="accessrestrict">
                <accessrestrict>
                    <p>
                        <xsl:value-of select="accessrestrict"/>
                    </p>
                </accessrestrict>
            </xsl:if>
        </c>
    </xsl:template>
    <!-- this is to demonstrate template processing -->
    <xsl:template name="event">
        <xsl:for-each select="//Event">
            <test>
                <xsl:value-of select="concat('Event no. ',position())"/>
            </test>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
