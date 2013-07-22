<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:isbn:1-931666-22-9" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:functx="http://www.functx.com" version="2.0"
    exclude-result-prefixes="#all">


    <xsl:template match="@*|node()|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()|processing-instruction()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:unitdate[.='' and @normal]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="@normal">
                <xsl:analyze-string select="."
                    regex="(\d{{4}})(-)?(\d{{2}})?(-)?(\d{{2}})?(/)?(\d{{4}})?(-)?(\d{{2}})?(-)?(\d{{2}})?">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                 
                    <xsl:if test="regex-group(3)">
                        <xsl:choose>
                            <xsl:when test="matches(regex-group(3), '01')">
                                <xsl:text> January</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="matches(regex-group(3), '02')">
                                        <xsl:text> February</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="matches(regex-group(3), '03')">
                                                <xsl:text> March</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when test="matches(regex-group(3), '04')">
                                                        <xsl:text> April</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:choose>
                                                            <xsl:when test="matches(regex-group(3), '05')">
                                                                <xsl:text> May</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:choose>
                                                                    <xsl:when test="matches(regex-group(3), '06')">
                                                                        <xsl:text> June</xsl:text>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:choose>
                                                                            <xsl:when test="matches(regex-group(3), '07')">
                                                                                <xsl:text> July</xsl:text>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                    <xsl:when test="matches(regex-group(3), '08')">
                                                                                        <xsl:text> August</xsl:text>
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="matches(regex-group(3), '09')">
                                                                                                <xsl:text> September</xsl:text>
                                                                                            </xsl:when>
                                                                                            <xsl:otherwise>
                                                                                                <xsl:choose>
                                                                                                    <xsl:when test="matches(regex-group(3), '10')">
                                                                                                        <xsl:text> October</xsl:text>
                                                                                                    </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                        <xsl:choose>
                                                                                                            <xsl:when test="matches(regex-group(3), '11')">
                                                                                                                <xsl:text> November</xsl:text>
                                                                                                            </xsl:when>
                                                                                                            <xsl:otherwise>
                                                                                                                <xsl:choose>
                                                                                                                    <xsl:when test="matches(regex-group(3), '12')">
                                                                                                                        <xsl:text> December</xsl:text>
                                                                                                                    </xsl:when>
                                                                                                                </xsl:choose>
                                                                                                            </xsl:otherwise>
                                                                                                        </xsl:choose>
                                                                                                    </xsl:otherwise>
                                                                                                </xsl:choose>
                                                                                            </xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>   
                        
                        <xsl:if test="regex-group(5)">
                            <xsl:text> </xsl:text><xsl:value-of select="replace(regex-group(5), '^0', '')"/>
                        </xsl:if>
                        
                        <xsl:if test="regex-group(6)">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        
                        <xsl:if test="regex-group(7)">
                            <xsl:value-of select="regex-group(7)"/>
                        </xsl:if>
                        
                        <xsl:if test="regex-group(9)">
                            <xsl:choose>
                                <xsl:when test="matches(regex-group(9), '01')">
                                    <xsl:text> January</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="matches(regex-group(9), '02')">
                                            <xsl:text> February</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="matches(regex-group(9), '03')">
                                                    <xsl:text> March</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="matches(regex-group(9), '04')">
                                                            <xsl:text> April</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:choose>
                                                                <xsl:when test="matches(regex-group(9), '05')">
                                                                    <xsl:text> May</xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:choose>
                                                                        <xsl:when test="matches(regex-group(9), '06')">
                                                                            <xsl:text> June</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:choose>
                                                                                <xsl:when test="matches(regex-group(9), '07')">
                                                                                    <xsl:text> July</xsl:text>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="matches(regex-group(9), '08')">
                                                                                            <xsl:text> August</xsl:text>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="matches(regex-group(9), '09')">
                                                                                                    <xsl:text> September</xsl:text>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:choose>
                                                                                                        <xsl:when test="matches(regex-group(9), '10')">
                                                                                                            <xsl:text> October</xsl:text>
                                                                                                        </xsl:when>
                                                                                                        <xsl:otherwise>
                                                                                                            <xsl:choose>
                                                                                                                <xsl:when test="matches(regex-group(9), '11')">
                                                                                                                    <xsl:text> November</xsl:text>
                                                                                                                </xsl:when>
                                                                                                                <xsl:otherwise>
                                                                                                                    <xsl:choose>
                                                                                                                        <xsl:when test="matches(regex-group(9), '12')">
                                                                                                                            <xsl:text> December</xsl:text>
                                                                                                                        </xsl:when>
                                                                                                                    </xsl:choose>
                                                                                                                </xsl:otherwise>
                                                                                                            </xsl:choose>
                                                                                                        </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        
                        <xsl:if test="regex-group(11)">
                            <xsl:text> </xsl:text><xsl:value-of select="replace(regex-group(11), '^0', '')"/>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>



</xsl:stylesheet>
