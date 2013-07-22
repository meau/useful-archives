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
                <fo:simple-page-master master-name="folderLabels" page-height="11in"
                    page-width="216mm" margin-top=".6in" margin-bottom=".4in" margin-left="4mm"
                    margin-right="4mm">
                    <fo:region-body margin-top="0in" margin-bottom="0in" column-count="2"
                        column-gap="0.6mm"/>
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


            <!-- If a range of folders is present, execute "multi" below -->

            <xsl:if
                test="ead:container[@type='Folder' or @type='folder' or @type='volume' or @type='Volume'][contains(., ' to ') or contains(., '-')]">
                <xsl:apply-templates mode="multi"
                    select="ead:container[@type='Folder' or @type='folder' or @type='volume' or @type='Volume'][contains(., ' to ') or contains(., '-')]"
                />
            </xsl:if>

            <!-- put single folders in the following cells: -->

            <xsl:if
                test="ead:container[@type='Folder' or @type='folder' or @type='volume' or @type='Volume'][not(contains(., ' to ') or contains(., '-'))]">
                <xsl:apply-templates mode="single"
                    select="ead:container[@type='Folder' or @type='folder' or @type='volume' or @type='Volume'][not(contains(., ' to ') or contains(., '-'))]"
                />
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template mode="single"
        match="ead:container[@type='Folder' or @type='folder' or @type='volume' or @type='Volume'][not(contains(., ' to ') or contains(., '-'))]">
        <!-- process parent level UPDATE 10/3/2011: parent level taken out due to recent change in descriptive practice-->
       <fo:table-row height="1in" padding-bottom=".2in" padding-top=".2in">
            <fo:table-cell>
                 <fo:block margin-left="0.2in">
      <!--              <fo:block font-weight="bold" font-size="13pt" font-family="Arial"
                        line-height="0.2in" text-align="start" span="none">
                        <xsl:choose>-->
                            <!--Exclude series/subseries and any unittitles in <emph>-->
                           <!-- <xsl:when test="../../../self::*[@level='series' or @level='subseries']"/>
                            <xsl:when
                                test="../../self::ead:c01[@level='file'] or ../../self::ead:c02[@level='file']"/>
                            <xsl:when test="ead:emph[@render]"/>
                            <xsl:otherwise>
                                <xsl:apply-templates select="../../../child::*/child::ead:unittitle"/>:     
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>-->
                    <!-- process child level -->
                    <fo:block font-weight="bold" font-family="Arial" font-size="13pt"
                        line-height="0.2in" text-align="start" span="none">
                            <fo:inline>
                                <xsl:choose>
                                    <xsl:when
                                        test="(following-sibling::ead:unittitle | preceding-sibling::ead:unittitle) =  normalize-space(following-sibling::ead:unitdate | preceding-sibling::ead:unitdate)">
                                        <xsl:value-of
                                            select="normalize-space(following-sibling::ead:unitdate | preceding-sibling::ead:unitdate)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="following-sibling::ead:unittitle | preceding-sibling::ead:unittitle"/>
                                        <xsl:text>, </xsl:text>
                                        <xsl:apply-templates select="following-sibling::ead:unitdate | preceding-sibling::ead:unitdate"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                

                            </fo:inline>
                    </fo:block>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>


    <!-- If a range of folders is present, create one label for each and put in the following cells: -->
    <xsl:template mode="multi"
        match="ead:container[@type='Folder' or @type='folder' or @type='Folders' or @type='folders' or @type='volume' or @type='Volume']/text()[contains(., ' to ') or contains(., '-')]">
        <xsl:variable name="unittitle-parent">
            <xsl:choose>
                <xsl:when test="../../../../self::*[@level='series' or @level='subseries']"/>
                <xsl:when
                    test="../../../self::ead:c01[@level='file'] or ../../self::ead:c02[@level='file'] or ../../self::ead:c[@level='file']"/>

                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when
                            test="../../../../child::*/child::ead:unittitle =  normalize-space(../../../../child::*/child::ead:unitdate)">
                            <xsl:value-of
                                select="normalize-space(../../../../child::*/child::ead:unitdate)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when
                                    test="ends-with(../../../../child::*/child::ead:unittitle, ',')">
                                    <xsl:value-of
                                        select="substring-before(../../../../child::*/child::ead:unittitle, ',')"
                                    />:</xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="../../../../child::*/child::ead:unittitle"
                                    />:</xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="unittitle-child">
            <xsl:choose>
                <xsl:when
                    test="substring-before(../../ead:unittitle, ', ') = ../../ead:unitdate ">
                    <xsl:value-of
                        select="normalize-space(preceding-sibling::ead:unitdate | following-sibling::ead:unitdate)"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="../../ead:unittitle"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="../../ead:unitdate"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="childPath" select="../../ead:unittitle"/>
        <xsl:variable name="childDatePath">
            <xsl:choose>
                <xsl:when test="../../ead:unitdate[2]">
                    <xsl:value-of select="../../ead:unitdate[1]"/>, <xsl:value-of
                        select="../../ead:unitdate[2]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="../../ead:unitdate"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="parentPath" select="../../../../child::*/child::ead:unittitle"/>

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
        <xsl:variable name="folderSeq" select="tokenize($postparser, ' ')"/>


        <xsl:for-each select="$folderSeq">
            <fo:table-row height="1in" padding-bottom=".2in" padding-top=".2in">
                <fo:table-cell>
                    <fo:block margin-left="0.2in">
<!--                        <fo:block font-size="13pt" font-weight="bold" font-family="Arial"
                            line-height="0.2in" text-align="start" span="none">
                            <fo:inline>-->
                        <!-- Process parent elements UPDATE 10/3/2011: parent level taken out due to recent change in descriptive practice-->
<!--                                <xsl:choose>
                                    <xsl:when test="$parentPath/ead:emph[@render='italic']">
                                        <fo:inline font-style="normal">
                                            <xsl:value-of
                                                select="substring-before(string($parentPath), string($parentPath/ead:emph[1]))"/>
                                            <fo:inline font-style="italic">
                                                <xsl:if
                                                    test="$parentPath/ead:emph[1] and not($parentPath/ead:emph[2])">
                                                    <xsl:value-of select="$parentPath/ead:emph[1]"/>
                                                    <fo:inline font-style="normal">
                                                        <xsl:value-of
                                                            select="substring-after(string($parentPath), string($parentPath/ead:emph[1]))"
                                                        />
                                                    </fo:inline>
                                                </xsl:if>
                                                <xsl:if test="$parentPath/ead:emph[2]">
                                                    <xsl:value-of select="$parentPath/ead:emph[1]"/>
                                                    <fo:inline font-style="normal">
                                                        <xsl:value-of
                                                            select="substring-before(substring-after(string($parentPath), string($parentPath/ead:emph[1])), string($parentPath/ead:emph[2]))"/>
                                                        
                                                        <fo:inline font-style="italic">
                                                            <xsl:value-of select="$parentPath/ead:emph[2]"/>
                                                            
                                                            <fo:inline font-style="normal">
                                                                <xsl:value-of
                                                                    select="substring-after(string($parentPath), string($parentPath/ead:emph[2]))"
                                                                />
                                                            </fo:inline>
                                                        </fo:inline>
                                                    </fo:inline>
                                                    
                                                </xsl:if>
                                                
                                            </fo:inline>
                                        </fo:inline>
                                    </xsl:when>
                                    <xsl:when test="$childPath/ead:emph[@render='doublequote']">
                                        <fo:inline font-style="normal">
                                            <xsl:value-of
                                                select="substring-before(string($childPath), string($childPath/ead:emph))"/>
                                            <fo:inline> "<xsl:value-of select="$childPath/ead:emph"/>"
                                                <fo:inline font-style="normal">
                                                    <xsl:value-of
                                                        select="substring-after(substring-before(string($childPath), string($childPath/ead:unitdate)), string($childPath/ead:emph))"/>
                                                    <fo:inline font-style="normal">
                                                        <xsl:value-of select="$childDatePath"/>
                                                    </fo:inline>
                                                </fo:inline>
                                            </fo:inline>
                                        </fo:inline>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <fo:inline>
                                            <xsl:value-of select="$unittitle-parent"/>
                                        </fo:inline>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:inline>
                        </fo:block>-->
                        <fo:block font-size="13pt" font-weight="bold" font-family="Arial"
                            line-height="0.2in" text-align="start" span="none">

                            <!-- Process child elements -->
                            <xsl:choose>
                                <xsl:when test="$childPath/ead:emph[@render='italic']">
                                    <fo:inline font-style="normal">
                                        <xsl:value-of
                                            select="substring-before(string($childPath), string($childPath/ead:emph[1]))"/>
                                        <fo:inline font-style="italic">
                                            <xsl:if
                                                test="$childPath/ead:emph[1] and not($childPath/ead:emph[2])">
                                                <xsl:value-of select="$childPath/ead:emph[1]"/>
                                                <fo:inline font-style="normal">
                                                  <xsl:value-of
                                                  select="substring-after(string($childPath), string($childPath/ead:emph[1]))"
                                                  />
                                                </fo:inline>
                                            </xsl:if>
                                            <xsl:if test="$childPath/ead:emph[2]">
                                                <xsl:value-of select="$childPath/ead:emph[1]"/>
                                                <fo:inline font-style="normal">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(string($childPath), string($childPath/ead:emph[1])), string($childPath/ead:emph[2]))"/>

                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of select="$childPath/ead:emph[2]"/>

                                                  <fo:inline font-style="normal">
                                                  <xsl:value-of
                                                  select="substring-after(string($childPath), string($childPath/ead:emph[2]))"
                                                  />
                                                  </fo:inline>
                                                  </fo:inline>
                                                </fo:inline>

                                            </xsl:if>

                                        </fo:inline>
                                    </fo:inline>
                                </xsl:when>
<!--                                <xsl:when test="$childPath/ead:emph[@render='doublequote']">
                                    <fo:inline font-style="normal">
                                        <xsl:value-of
                                            select="substring-before(string($childPath), string($childPath/ead:emph))"/>
                                        <fo:inline> "<xsl:value-of select="$childPath/ead:emph"/>"
                                                <fo:inline font-style="normal">
                                                <xsl:value-of
                                                  select="substring-after(substring-before(string($childPath), string($childPath/ead:unitdate)), string($childPath/ead:emph))"/>
                                                <fo:inline font-style="normal">
                                                  <xsl:value-of select="$childDatePath"/>
                                                </fo:inline>
                                            </fo:inline>
                                        </fo:inline>
                                    </fo:inline>
                                </xsl:when>-->
                                <xsl:otherwise>
                                    <fo:inline>
                                        <xsl:value-of select="$unittitle-child"/>
                                    </fo:inline>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                        <fo:block>
                            <fo:inline> (Folder <xsl:value-of select="position()"/> of <xsl:value-of
                                    select="count($folderSeq)"/>)</fo:inline>
                        </fo:block>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:for-each>

    </xsl:template>
    <xsl:template match="ead:emph[@render='italic']">
        <fo:inline>
            <xsl:attribute name="font-style">italic</xsl:attribute>
            <xsl:apply-templates/>
            <!--<xsl:text>, </xsl:text>-->
        </fo:inline>
    </xsl:template>

    <xsl:template match="ead:emph[@render='doublequote']">
        <fo:inline> "<xsl:apply-templates/>,"</fo:inline>
    </xsl:template>


</xsl:stylesheet>
