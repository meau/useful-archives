<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:njp="http://diglib.princeton.edu" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/2005/xpath-functions">
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>

    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="boxLabels" page-height="278mm"
                    page-width="216mm" margin-top="10mm" margin-bottom="10mm" margin-left="7mm"
                    margin-right="7mm">
                    <fo:region-body margin-top="0in" margin-bottom="0in" column-count="2"
                        column-gap="10mm"/>
                    <fo:region-before extent="0cm"/>
                    <fo:region-after extent="0cm"/>
                </fo:simple-page-master>

                <fo:page-sequence-master master-name="repeatME">
                    <fo:repeatable-page-master-reference master-reference="boxLabels"/>
                </fo:page-sequence-master>
            </fo:layout-master-set>
            <xsl:apply-templates select="ead:ead"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="ead:ead">
        <fo:page-sequence master-reference="repeatME">
            <fo:flow flow-name="xsl-region-body">
                <fo:table>
                    <fo:table-column column-width="96mm"/>
                    <fo:table-body font-family="Arial">
                        <xsl:apply-templates select="//ead:dsc"/>
                    </fo:table-body>
                </fo:table>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:template match="ead:container[@type='Box' or @type='box' or @type='volume' or @type='Volume']">

        <xsl:for-each select=".[not(.=preceding::ead:container[@type='Box' or @type='box'  or @type='volume' or @type='Volume'])]">

            <!-- If a range of boxes is present, execute "multi" below -->
            <xsl:if test=".[contains(., ' to ') or contains(., '-')]">
                <xsl:apply-templates mode="multi" select="."/>
            </xsl:if>

            <!-- otherwise, put single boxes in the following cells: -->
            <xsl:if test=".[not(contains(., ' to ') or contains(., '-'))]">
                <xsl:apply-templates mode="single" select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template mode="single"
        match="ead:container[@type='Box' or @type='box' or @type='volume' or @type='Volume'][not(contains(., ' to ') or contains(., '-'))]">
        <fo:table-row height="3.3in" padding-bottom=".2in" padding-top=".2in" margin-left="3mm"
            margin-right="3mm">
            <fo:table-cell>
                <fo:block padding-bottom=".2in" padding-top=".2in" padding-left="2mm"
                    padding-right="2mm" border-color="black" border-style="solid"
                    border-width="thin" margin-top="9mm">
                    <fo:block font-weight="bold" font-size="16pt" font-family="Arial"
                        text-align="center" span="none" padding-after="12pt">
                        <xsl:value-of select="//ead:archdesc/ead:did/ead:unittitle"/>
                    </fo:block>
                    <fo:block font-weight="bold" font-family="Arial" font-size="13pt"
                        line-height="0.2in" text-align="center" span="none">
                        <xsl:value-of select="./ancestor::*[@level='series']/ead:did/ead:unittitle"
                        />
                    </fo:block>
                    <fo:block font-weight="bold" font-family="Arial" font-size="11pt"
                        line-height="0.3in" text-align-last="justify" padding-before="10pt">
                        <xsl:value-of select="//ead:eadid"/>
                        <fo:leader leader-pattern="space"/>
                        <xsl:value-of
                            select="concat(upper-case(substring(normalize-space(@type),1,1)),
                            substring(normalize-space(@type), 2))"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                    </fo:block>
                    <fo:block text-align="left" line-height=".3" vertical-align="after">
                        <fo:external-graphic
                            src="C:\Documents and Settings\heberlei\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\delaney\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\vaddoniz\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Users\mssstu1\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\kbalatso\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\hmengel\Desktop\msslogo.JPG"/>
                    </fo:block>
                    <fo:block font-weight="bold" font-family="Arial" font-size="11pt"
                        line-height="0.3in" span="none" text-align="center" vertical-align="after" padding-before="14pt">
                        <xsl:text>Princeton University Library</xsl:text>
                    </fo:block>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>


    <xsl:variable name="collectiontitle" select="//ead:archdesc/ead:did/ead:unittitle"/>
    <xsl:variable name="eadid" select="//ead:eadid"/>

    <!-- If a range of boxes is present, create one label for each and put in the following cells: -->
    <xsl:template mode="multi"
        match="ead:container[@type='Box' or @type='box' or @type='volume' or @type='Volume']/text()[contains(., ' to ') or contains(., '-')]">
        <xsl:variable name="boxLabel">
            <xsl:value-of
                select="concat(upper-case(substring(normalize-space(../@type),1,1)),
                substring(normalize-space(../@type), 2))"/>
            <xsl:text> </xsl:text>
        </xsl:variable>
        <xsl:variable name="series-title"
            select="./ancestor::*[@level='series']/ead:did/ead:unittitle"/>

        <xsl:variable name="before" select="substring-before(., ' to ') cast as xs:integer"/>
        <xsl:variable name="after" select="substring-after(., ' to ') cast as xs:integer"/>
        <xsl:variable name="before1" select="substring-before(., '-') cast as xs:integer"/>
        <xsl:variable name="after1" select="substring-after(., '-') cast as xs:integer"/>
        <xsl:variable name="parser">
            <xsl:choose>
                <xsl:when test="contains(., ' to ')">
                    <xsl:value-of select="($before to $after)"/>
                </xsl:when>
                <xsl:when test="contains(., '-')">
                    <xsl:value-of select="($before1 to $after1)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="postparser" select="substring($parser, 1) cast as xs:string"/>
        <xsl:variable name="boxSeq" select="tokenize($postparser, ' ')"/>

        <xsl:for-each select="$boxSeq">
            <fo:table-row height="3.3in" padding-bottom=".2in" padding-top=".2in" margin-left="3mm"
                margin-right="3mm">
                <fo:table-cell>
                    <fo:block padding-bottom=".2in" padding-top=".2in" padding-left="2mm"
                        padding-right="2mm" border-color="black" border-style="solid"
                        border-width="thin" margin-top="9mm">
                        <fo:block font-weight="bold" font-size="16pt" font-family="Arial"
                            text-align="center" span="none" padding-after="12pt">
                            <xsl:value-of select="$collectiontitle"/>
                        </fo:block>
                        <fo:block font-weight="bold" font-family="Arial" font-size="13pt"
                            line-height="0.2in" text-align="center" span="none">
                            <xsl:value-of select="$series-title"/>
                        </fo:block>
                        <fo:block font-weight="bold" font-family="Arial" font-size="11pt"
                            line-height="0.3in" text-align-last="justify" padding-before="10pt">
                            <xsl:value-of select="$eadid"/>
                            <fo:leader leader-pattern="space"/>
                            <xsl:value-of select="$boxLabel"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="."/>
                            <xsl:text> </xsl:text>
                        </fo:block>
                        <fo:block text-align="left" line-height=".3" vertical-align="after">
                            <fo:external-graphic
                                src="C:\Documents and Settings\heberlei\Desktop\msslogo.JPG"/>
                        </fo:block>
                        <fo:external-graphic
                            src="C:\Documents and Settings\anmeyers\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\delaney\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\vaddoniz\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\spyu\Desktop\msslogo.JPG"/>
                        <fo:external-graphic
                            src="C:\Documents and Settings\kbalatso\Desktop\msslogo.JPG"/>
                        <fo:block font-weight="bold" font-family="Arial" font-size="11pt"
                            line-height="0.3in" span="none" text-align="center" vertical-align="after">
                            <xsl:text>Princeton University Library</xsl:text>
                        </fo:block>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
