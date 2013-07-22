<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet created by Jon Stroop on 2/23/2011 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:local="local.uri" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
    <xsl:output indent="yes"/>

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="folderLabels" page-height="11in"
                    page-width="8.5in" margin-top=".6in" margin-bottom=".4in" margin-left="5mm"
                    margin-right="5mm">
                    <fo:region-body margin-top="0in" margin-bottom="0in" column-count="3"
                        column-gap="3mm"/>
                    <fo:region-before extent="0cm"/>
                    <fo:region-after extent="0cm"/>
                </fo:simple-page-master>
                <fo:page-sequence-master master-name="repeatME">
                    <fo:repeatable-page-master-reference master-reference="folderLabels"/>
                </fo:page-sequence-master>
            </fo:layout-master-set>
            <xsl:apply-templates select="ead:ead"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="ead:ead">
        <fo:page-sequence master-reference="repeatME">
            <fo:flow flow-name="xsl-region-body">
                <fo:table>
                    <fo:table-column column-width="6.7cm"/>
                    <fo:table-body>
                        <xsl:apply-templates select="/" mode="dsc"/>
                    </fo:table-body>
                </fo:table>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:key name="containerType" match="ead:container">
        <xsl:value-of select="normalize-space(lower-case(@type))"/>
    </xsl:key>

    <xsl:function name="local:compute-box-folder-combos">
        <xsl:param name="component" as="element()"/>
        <xsl:variable name="bf-groups" as="element()*">
            <xsl:for-each-group
                select="$component//ead:container[matches(@type, 'folder|box|volume', 'i')]"
                group-starting-with="key('containerType', 'box')">
                <group>
                    <xsl:copy-of select="current-group()"/>
                </group>
            </xsl:for-each-group>
        </xsl:variable>

        <xsl:for-each select="$bf-groups">
            <xsl:variable name="box" select="ead:container[1]" as="xs:string"/>
            <xsl:variable name="folder-elements" as="xs:string*">
                <xsl:for-each select="ead:container[position() > 1]">
                    <xsl:value-of select="normalize-space(current())"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="folders" as="xs:string*">
                <xsl:for-each select="$folder-elements">
                    <xsl:choose>
                        <xsl:when test="current() castable as xs:integer">
                            <xsl:value-of select="current()"/>
                        </xsl:when>
                        <xsl:when test="count(tokenize(current(), '-')) = 2">
                            <xsl:variable name="tokens" select="tokenize(current(), '-')"
                                as="xs:string+"/>
                            <xsl:for-each select="xs:integer($tokens[1]) to xs:integer($tokens[2]) ">
                                <xsl:value-of select="current()"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message terminate="no">
                                <xsl:text>Found a folder pattern I don't recognize: </xsl:text>
                                <xsl:value-of select="current()"/>
                            </xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="label" as="xs:string*">
                <xsl:for-each select="ead:container[position() > 1]/@type">
                    <xsl:value-of
                        select="concat(upper-case(substring(normalize-space(current()),1,1)),
                        substring(normalize-space(current()), 2))"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="$folders">
                <xsl:value-of select="concat('Box ', $box, '           ', $label, ' ', current())"/>
            </xsl:for-each>

        </xsl:for-each>
    </xsl:function>



    <xsl:template match="/" mode="dsc">
        <xsl:variable name="box-folders">
            <bfs-tmp>
                <xsl:for-each
                    select="//*[(matches(local-name(), 'c0\d') or matches(local-name(), 'c')) and 
                    ./ead:did/ead:container[matches(@type, 'box|volume', 'i')] and 
                    ./ead:did/ead:container[matches(@type, 'folder|volume', 'i')]]">
                    <xsl:for-each select="local:compute-box-folder-combos(current())">

                        <bf>
                            <xsl:copy-of select="current()"/>
                            <!--                            <foo>
                                <xsl:value-of select="if (contains(current(), 'Folder')) 
                                    then substring-before(substring-after(normalize-space(string()), 'Box'), 'Folder') cast as xs:integer
                                    else substring-before(substring-after(normalize-space(string()), 'Box'), 'Division') cast as xs:integer"></xsl:value-of>
                            </foo>-->
                        </bf>

                    </xsl:for-each>

                </xsl:for-each>
            </bfs-tmp>
        </xsl:variable>
        <xsl:variable name="titleproper" select="//ead:archdesc/ead:did/ead:unittitle"/>
        <!--<xsl:copy-of select="$box-folders"/>-->

        <xsl:for-each select="distinct-values($box-folders//bf)">

            <xsl:sort
                select="if (contains(string(), 'folder')) 
                                      then substring-before(substring-after(normalize-space(string()), 'box'), 'folder')
                                      else if (contains(string(), 'volume'))
                                      then substring-before(substring-after(normalize-space(string()), 'box'), 'volume')
                                      else ()"/>

            <fo:table-row height="1in" padding-bottom=".2in" padding-top=".2in">
                <fo:table-cell margin-right="2mm" margin-left="2mm">
                    <fo:block padding-left=".1in" padding-right=".1in">
                        <fo:block font-weight="bold" font-size="12pt" font-family="Arial"
                            line-height="0.2in" text-align="center" text-align-last="center"
                            span="none" padding-bottom="4pt">
                            <xsl:value-of select="$titleproper"/>
                        </fo:block>
                        <fo:block font-weight="bold" font-size="11pt" font-family="Arial"
                            line-height="0.2in" text-align-last="justify" span="none"
                            text-indent=".1in" white-space-collapse="false">
                            <xsl:value-of select="current()"/>
                        </fo:block>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>

        </xsl:for-each>


    </xsl:template>

</xsl:stylesheet>
