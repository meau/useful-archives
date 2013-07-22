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
                <fo:simple-page-master master-name="boxLabels" page-height="11in"
                    page-width="216mm" margin-top=".6in" margin-bottom=".4in">
                    <fo:region-body margin-top="0in" margin-bottom="0in" column-count="2"
                        column-gap="0.6mm"/>
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
                    <fo:table-column column-width="101mm"/>
                    <fo:table-body font-family="Arial">
                        <xsl:apply-templates select="//ead:dsc"/>
                    </fo:table-body>
                </fo:table>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>



    <xsl:template match="//ead:dsc">
        <xsl:for-each select="descendant::ead:*">
            <!-- If a range of boxes is present, execute "multi" below -->
            <xsl:if
                test="ead:container[@type='Box' or @type='box' or @type='volume' or @type='Volume'][contains(., ' to ') or contains(., '-')]">
                <xsl:apply-templates mode="multi"
                    select="current()"
                />
            </xsl:if>
            <!-- put single boxes in the following cells: -->
            <xsl:if
                test="ead:container[(@type='Box' or @type='box' or @type='volume' or @type='Volume') and not(contains(., ' to ') or contains(., '-'))]">                
                <xsl:apply-templates mode="single"
                    select="current()"
                />
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:variable name="eadid"><xsl:value-of select="//ead:eadid"/></xsl:variable>

    <xsl:template mode="single"
        match="ead:container[(@type='Box' or @type='box' or @type='volume' or @type='Volume') and not(contains(., ' to ') or contains(., '-'))]/text()[not(.=preceding::ead:container[(@type='Box' or @type='box' or @type='volume' or @type='Volume') and not(contains(., ' to ') or contains(., '-'))]/text())]">       
    <fo:table-row height="2in" padding-bottom=".5in" padding-top=".5in">
            <fo:table-cell>
                 <fo:block>
                    <fo:block font-weight="bold" font-family="Arial" font-size="85pt"
                        line-height="1in" text-align="center" span="none" margin-top=".5in" margin-left="6mm">
                            <fo:inline>
<xsl:value-of select="$eadid"/>
                            </fo:inline>
                    </fo:block>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>


    <!-- If a range of folders is present, create one label for each and put in the following cells: -->
    <xsl:template mode="multi"
        match="ead:container[(@type='Box' or @type='box' or @type='Boxes' or @type='boxes' or @type='volume' or @type='Volume') and contains(., ' to ') or contains(., '-')]/text()[
        not(.=preceding::ead:container[(@type='Box' or @type='box' or @type='Boxes' or @type='boxes' or @type='volume' or @type='Volume') and contains(., ' to ') or contains(., '-')]/text())]">
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
            <fo:table-row height="2in" padding-bottom=".5in" padding-top=".5in">
                <fo:table-cell>
                    <fo:block>
                        <fo:block font-size="85pt" font-weight="bold" font-family="Arial"
                            line-height="1in" text-align="center" span="none" margin-top=".5in" margin-left="6mm">
                            <fo:inline>
                                <xsl:value-of select="$eadid"/>
                            </fo:inline>
                        </fo:block>                        
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
