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

    <xsl:template match="/">
        <dsc type="combined">
            <xsl:apply-templates select="//mods:mods"/>
        </dsc>

    </xsl:template>

    <xsl:template match="mods:mods">
        <c01 level="file">
            <did>
                <unittitle>
                    <xsl:apply-templates select="mods:titleInfo/mods:title"/>
                </unittitle>
                <unitdate>
                    <xsl:apply-templates select="mods:originInfo/mods:dateOther"/>
                </unitdate>
                <container type="volume">
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
            <xsl:if test="mods:note">
                <scopecontent>
                    <p>
                        <xsl:apply-templates select="mods:note"/>
                    </p>
                </scopecontent>
            </xsl:if>
            <controlaccess>
                <xsl:for-each
                    select="mods:genre[not(matches(., '^Albumen prints$|^Expedition photographs$|^Ethnographic photographs$|^Portrait photographs$|^Group portraits$'))]">
                    <genreform>
                        <xsl:apply-templates select="text()"/>
                    </genreform>
                </xsl:for-each>
                <xsl:for-each
                    select="mods:subject/mods:topic[not(matches(., '^Ruins$|^Buildings$|^Manners and customs$|^Clothing$'))]">
                    <subject>
                        <xsl:apply-templates select="text()"/>
                    </subject>
                </xsl:for-each>
                <xsl:for-each select="mods:subject/mods:geographic">
                    <geogname>
                        <xsl:apply-templates select="text()"/>
                    </geogname>
                </xsl:for-each>
            </controlaccess>
        </c01>
    </xsl:template>

    <xsl:template match="mods:note">
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
        <xsl:value-of select="replace(., '\(WA\)\sWC\d{3},\s', '')"/>
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
