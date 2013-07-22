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

    <xsl:function name="functx:substring-after-last-match" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="regex" as="xs:string"/>
        <xsl:sequence select=" 
            replace($arg,concat('^.*',$regex),'')
            "/>
    </xsl:function>

    <xsl:function name="functx:substring-before-last-match" as="xs:string?"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="regex" as="xs:string"/>
        <xsl:sequence
            select=" 
            replace($arg,concat('^(.*)',$regex,'.*'),'$1')
            "/>
    </xsl:function>

    <xsl:function name="functx:pad-integer-to-length" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>
        <xsl:sequence
            select=" 
            if ($length &lt; string-length(string($integerToPad)))
            then error(xs:QName('functx:Integer_Longer_Than_Length'))
            else concat
            (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
            string($integerToPad))
            "        />
    </xsl:function>

    <xsl:function name="functx:repeat-string" as="xs:string" xmlns:functx="http://www.functx.com">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        <xsl:sequence
            select=" 
            string-join((for $i in 1 to $count return $stringToRepeat),
            '')
            "        />
    </xsl:function>

    <xsl:template
        match="ead:unitdate[matches(., '^undated$') and ../../descendant::ead:c/ead:did/ead:unitdate[@normal]]">
        <unitdate>
            <xsl:attribute name="normal">
                <xsl:variable name="start-year" as="xs:integer+">
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[matches(., '/')]">
                        <xsl:if test="matches(., '\d{4}/')">
                            <xsl:value-of select="substring-before(., '/')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '\d{4}-\d{2}/')">
                            <xsl:value-of select="substring-before(., '-')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '\d{4}-\d{2}-\d{2}/')">
                            <xsl:value-of select="substring-before(., '-')"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[not(matches(., '/'))]">
                        <xsl:if test="matches(., '^\d{4}$')">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}$')">
                            <xsl:value-of select="substring-before(., '-')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:value-of select="substring-before(., '-')"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="end-year" as="xs:integer+">
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[matches(., '/')]">
                        <xsl:if test="matches(., '/\d{4}$')">
                            <xsl:value-of select="substring-after(., '/')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '/\d{4}-\d{2}$')">
                            <xsl:value-of select="substring-before(substring-after(., '/'), '-')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '/\d{4}-\d{2}-\d{2}$')">
                            <xsl:value-of select="substring-before(substring-after(., '/'), '-')"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[not(matches(., '/'))]">
                        <xsl:if test="matches(., '^\d{4}$')">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}$')">
                            <xsl:value-of select="substring-before(., '-')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:value-of select="substring-before(., '-')"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="start-month" as="xs:integer*">
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[matches(., '/')]">
                        <xsl:if test="matches(., '^\d{4}/')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '/')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">1</xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}/')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                                <xsl:value-of
                                    select="substring-before(substring-after(., '-'), '/')"/>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}/')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                                <xsl:variable name="token1">
                                    <xsl:value-of select="substring-after(., '-')"/>
                                </xsl:variable>
                                <xsl:variable name="token-final">
                                    <xsl:value-of select="substring-before($token1, '-')"/>
                                </xsl:variable>
                                <xsl:value-of select="$token-final"/>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[not(matches(., '/'))]">
                        <xsl:if test="matches(., '^\d{4}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="."/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">1</xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                                <xsl:value-of select="substring-after(., '-')"/>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                                <xsl:variable name="token1" select="substring-after(., '-')"/>
                                <xsl:variable name="token-final"
                                    select="substring-before($token1, '-')"/>
                                <xsl:value-of select="$token-final"/>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="end-month" as="xs:integer*">
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[matches(., '/')]">
                        <xsl:if test="matches(., '/\d{4}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-after(., '/')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">12</xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '/\d{4}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of
                                    select="substring-after(functx:substring-before-last-match(., '-'), '/')"
                                />
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:value-of select="functx:substring-after-last-match(., '-')"/>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '/\d{4}-\d{2}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:variable name="token1">
                                    <xsl:value-of select="substring-after(., '/')"/>
                                </xsl:variable>
                                <xsl:variable name="token-final">
                                    <xsl:value-of select="substring-before($token1, '-')"/>
                                </xsl:variable>
                                <xsl:value-of select="$token-final"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="token1">
                                    <xsl:value-of select="substring-after(., '/')"/>
                                </xsl:variable>
                                <xsl:variable name="token2">
                                    <xsl:value-of select="substring-after($token1, '-')"/>
                                </xsl:variable>
                                <xsl:variable name="token-final">
                                    <xsl:value-of select="substring-before($token2, '-')"/>
                                </xsl:variable>
                                <xsl:value-of select="$token-final"/>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[not(matches(., '/'))]">
                        <xsl:if test="matches(., '^\d{4}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="."/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">12</xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:value-of select="substring-after(., '-')"/>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="token1">
                                    <xsl:value-of select="substring-after(., '-')"/>
                                </xsl:variable>
                                <xsl:variable name="token-final">
                                    <xsl:value-of select="substring-before($token1, '-')"/>
                                </xsl:variable>
                                <xsl:value-of select="$token-final"/>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="start-day" as="xs:integer*">
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[matches(., '/')]">
                        <xsl:if test="matches(., '^\d{4}/')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '/')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                            <xsl:variable name="compare-month">1</xsl:variable>
                            <xsl:if test="$compare-month=min($start-month)">1</xsl:if>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}/')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                            <xsl:variable name="compare-month">
                                <xsl:value-of select="substring-before(substring-after(., '-'), '/')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-month=min($start-month)">1</xsl:if>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}/')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                            <xsl:variable name="compare-month">
                                <xsl:value-of select="substring-before(substring-after(., '-'), '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-month=min($start-month)">
                                <xsl:variable name="token1">
                                    <xsl:value-of select="substring-before(., '/')"/>
                                </xsl:variable>
                                <xsl:variable name="token-final">
                                    <xsl:value-of select="functx:substring-after-last-match($token1, '-')"/>
                                </xsl:variable>
                                <xsl:value-of select="$token-final"/>
                            </xsl:if>
                        </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[not(matches(., '/'))]">
                        <xsl:if test="matches(., '^\d{4}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="."/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                            <xsl:variable name="compare-month">1</xsl:variable>
                            <xsl:if test="$compare-month=min($start-month)">1</xsl:if>
                             </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                            <xsl:variable name="compare-month">
                                <xsl:value-of select="substring-after(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-month=min($start-month)">1</xsl:if>
                        </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=min($start-year)">
                            <xsl:variable name="compare-month">
                                <xsl:value-of select="substring-before(substring-after(., '-'), '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-month=min($start-month)">
                                <xsl:value-of select="functx:substring-after-last-match(., '-')"/>
                            </xsl:if>
                        </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                
                
               <xsl:variable name="end-day" as="xs:integer*">
                    <xsl:for-each
                        select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[matches(., '/')]">
                        <xsl:if test="matches(., '/\d{4}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-after(., '/')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="compare-month">12</xsl:variable>
                                <xsl:if test="$compare-month=max($end-month)">31</xsl:if>
                            </xsl:if>
                        </xsl:if>
                     <xsl:if test="matches(., '/\d{4}-\d{2}$')">
                            <xsl:variable name="compare-year">
                               <xsl:variable name="token1">
                                   <xsl:value-of select="substring-after(., '/')"/>
                               </xsl:variable>
                                <xsl:variable name="token-final">
                                    <xsl:value-of select="substring-before($token1, '-')"/>
                                </xsl:variable>
                                <xsl:value-of select="$token-final"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="compare-month">
                                    <xsl:variable name="token1">
                                        <xsl:value-of select="substring-after(., '/')"/>
                                    </xsl:variable>
                                    <xsl:variable name="token-final">
                                    <xsl:value-of select="substring-after($token1, '-')"/>
                                    </xsl:variable>
                                    <xsl:value-of select="$token-final"/>
                                </xsl:variable>
                                <xsl:if test="$compare-month=max($end-month)">31</xsl:if>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '/\d{4}-\d{2}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:variable name="token1">
                                    <xsl:value-of select="substring-after(., '/')"/>
                                </xsl:variable>
                                <xsl:variable name="token-final">
                                    <xsl:value-of select="substring-before($token1, '-')"/>
                                </xsl:variable>
                                <xsl:value-of select="$token-final"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="compare-month">
                                    <xsl:variable name="token1">
                                        <xsl:value-of select="functx:substring-before-last-match(., '-')"/>
                                    </xsl:variable>
                                    <xsl:variable name="token-final">
                                        <xsl:value-of select="functx:substring-after-last-match($token1, '-')"/>
                                    </xsl:variable>
                                    <xsl:value-of select="$token-final"/>
                                </xsl:variable>
                                <xsl:if test="$compare-month=max($end-month)">
                                    <xsl:value-of select="functx:substring-after-last-match(., '-')"/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                  <xsl:for-each
                      select="./../../descendant::ead:c/ead:did/ead:unitdate/@normal[not(matches(., '/'))]">
                        <xsl:if test="matches(., '^\d{4}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="."/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="compare-month">12</xsl:variable>
                                <xsl:if test="$compare-month=max($end-month)">31</xsl:if>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="compare-month">
                                    <xsl:value-of select="substring-after(., '-')"/>
                                </xsl:variable>
                                <xsl:if test="$compare-month=max($end-month)">31</xsl:if>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="matches(., '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:variable name="compare-year">
                                <xsl:value-of select="substring-before(., '-')"/>
                            </xsl:variable>
                            <xsl:if test="$compare-year=max($end-year)">
                                <xsl:variable name="compare-month">
                                    <xsl:value-of select="substring-before(substring-after(., '-'), '-')"/>
                                </xsl:variable>
                                <xsl:if test="$compare-month=max($end-month)">
                                    <xsl:value-of select="functx:substring-after-last-match(., '-')"/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable> 
                
                
                
                <xsl:variable name="start-month-string">
                    <xsl:for-each select="string(min($start-month))">
                        <xsl:if test="string-length(.)=1">
                            <xsl:value-of select="0"/>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="end-month-string">
                    <xsl:for-each select="string(max($end-month))">
                        <xsl:if test="string-length(.)=1">
                            <xsl:value-of select="0"/>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="start-day-string">
                    <xsl:for-each select="string(min($start-day))">
                        <xsl:if test="string-length(.)=1">
                            <xsl:value-of select="0"/>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="end-day-string">
                    <xsl:for-each select="string(max($end-day))">
                        <xsl:if test="string-length(.)=1">
                            <xsl:value-of select="0"/>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:value-of select="min($start-year)"/>
                <xsl:for-each select="(min($start-year))">-<xsl:value-of
                        select="$start-month-string"/>
                </xsl:for-each>
                <xsl:for-each select="(min($start-month))">-<xsl:value-of
                    select="$start-day-string"/>
                </xsl:for-each
                >/<xsl:value-of select="max($end-year)"/>
                <xsl:for-each select="(max($end-year))">-<xsl:value-of 
                    select="$end-month-string"/>
                </xsl:for-each>
                <xsl:for-each select="(max($end-month))">-<xsl:value-of 
                    select="$end-day-string"/>
                </xsl:for-each>
            </xsl:attribute>            
        </unitdate>        
    </xsl:template>


    
</xsl:stylesheet>
