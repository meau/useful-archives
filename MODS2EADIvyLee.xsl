<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:functx="http://www.functx.com"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="mods">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

    <xsl:function name="functx:substring-before-last" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>

        <xsl:sequence
            select=" 
            if (matches($arg, functx:escape-for-regex($delim)))
            then replace($arg,
            concat('^(.*)', functx:escape-for-regex($delim),'.*'),
            '$1')
            else ''
            "
        />
    </xsl:function>

    <xsl:function name="functx:escape-for-regex" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence
            select=" 
            replace($arg,
            '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
            "
        />
    </xsl:function>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!--    <xsl:template match="/">
        <dsc type="combined">
            <xsl:apply-templates select="//mods:mods"/>
        </dsc>

    </xsl:template>-->

    <xsl:template match="mods:mods">
        <c level="item">
            <did>
                <unitid>
                    <xsl:value-of select="mods:recordInfo/mods:recordIdentifier"/>
                </unitid>
                <unittitle>
                    <xsl:if test="mods:titleInfo/mods:nonSort">
                        <xsl:value-of select="mods:titleInfo/mods:nonSort"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="mods:titleInfo/mods:title"/>
                </unittitle>
                <unitdate>
                    <xsl:attribute name="normal">
                        <xsl:value-of select="mods:originInfo/mods:dateCreated"/>
                    </xsl:attribute>
                    <!-- Need to figure out how to transform normalized dates into AACR2 dates -->
                </unitdate>
                <container type="box">
                    <xsl:apply-templates select="mods:location//mods:shelfLocator"/>
                </container>
                <physdesc>
                    <extent>
                        <xsl:apply-templates select="mods:physicalDescription/mods:extent"/>
                    </extent>
                    <!--                    <physfacet>
                        <xsl:apply-templates select="mods:typeOfResource"/>
                    </physfacet>-->
                </physdesc>

                <origination label="creator">
                    <xsl:for-each select="mods:name">
                        <persname role="cre">
                            <xsl:attribute name="source">
                                <xsl:value-of select="@authority"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="mods:namePart"/>
                        </persname>
                    </xsl:for-each>
                </origination>
            </did>
            <xsl:if test="mods:abstract|mods:relatedItem">
                <scopecontent>
                    <xsl:if test="mods:abstract"/>
                    <p>
                        <xsl:apply-templates select="mods:abstract"/>
                    </p>
                    <xsl:if test="mods:relatedItem"/>
                    <p>
                        <xsl:text>From </xsl:text>
                        <title render="italic">
                        <xsl:value-of select="mods:relatedItem/mods:titleInfo/mods:nonSort"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="mods:relatedItem[@type='series']/mods:titleInfo/mods:title"/>
                        </title>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="mods:relatedItem/mods:titleInfo/mods:partNumber[1]"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="mods:relatedItem/mods:titleInfo/mods:partNumber[2]"/>
                        <xsl:text>.</xsl:text>
                    </p>
                </scopecontent>
            </xsl:if>
            <controlaccess>
                <xsl:for-each select="mods:subject/mods:genre">
                    <genreform source="aat">
                        <xsl:apply-templates select="text()"/>
                    </genreform>
                </xsl:for-each>
                <xsl:for-each select="mods:subject/mods:topic">
                    <subject source="lcsh">
                        <xsl:apply-templates select="text()"/>
                    </subject>
                </xsl:for-each>
                <xsl:for-each select="mods:subject/mods:geographic">
                    <geogname source="lcsh">
                        <xsl:apply-templates select="text()"/>
                    </geogname>
                </xsl:for-each>
            </controlaccess>
        </c>
    </xsl:template>

    <xsl:template match="mods:abstract">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mods:name/mods:namePart">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mods:typeOfResource">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mods:physicalDescription/mods:extent">
        <xsl:choose>
            <xsl:when test="matches(normalize-space(string(.)), '\.$')">
                <xsl:value-of select="functx:substring-before-last(., '.')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="mods:originInfo/mods:dateOther">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mods:location//mods:shelfLocator">
        <xsl:value-of select="substring-after(.,'Box ')"/>
    </xsl:template>

    <xsl:template match="mods:titleInfo/mods:title">
        <xsl:choose>
            <xsl:when test="matches(normalize-space(string(.)), '\.$')">
                <xsl:value-of select="functx:substring-before-last(., '.')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
