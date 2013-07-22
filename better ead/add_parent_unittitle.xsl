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

    <xsl:template match="@*|node()|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()|processing-instruction()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:did[not(ead:unittitle)]">
        <xsl:choose>
            <xsl:when test="../../ead:did/ead:unittitle">
                <xsl:copy>
                <xsl:copy-of select="current()/*|processing-instruction()|comment()"/>
                <xsl:copy-of select="../../ead:did/ead:unittitle"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="../../../ead:did/ead:unittitle">
                        <xsl:copy>
                            <xsl:copy-of select="current()/*|comment()|processing-instruction()"/>
                            <xsl:copy-of select="../../../ead:did/ead:unittitle"/>
                        </xsl:copy>
                    </xsl:when>
                   <!-- <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="../../../../ead:did/ead:unittitle">
                                <xsl:copy>
                                    <xsl:copy-of select="current()/*"/>
                                    <xsl:copy-of select="../../../../ead:did/ead:unittitle"/>
                                </xsl:copy>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="../../../../../ead:did/ead:unittitle">
                                        <xsl:copy>
                                            <xsl:copy-of select="current()/*"/>
                                            <xsl:copy-of select="../../../../../ead:did/ead:unittitle"/>
                                        </xsl:copy>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="../../../../../../ead:did/ead:unittitle">
                                                <xsl:copy>
                                                    <xsl:copy-of select="current()/*"/>
                                                    <xsl:copy-of select="../../../../../../ead:did/ead:unittitle"/>
                                                </xsl:copy>
                                            </xsl:when>-->
                                            <xsl:otherwise>
                                                <xsl:message>Couldn't find a
                                                  unittitle.</xsl:message>
                                            </xsl:otherwise>
                                        <!--</xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>-->
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
