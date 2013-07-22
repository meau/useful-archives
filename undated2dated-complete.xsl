<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:isbn:1-931666-22-9" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:functx="http://www.functx.com" version="2.0"
    exclude-result-prefixes="#all">
    
    <!-- This stylesheet looks at explicitly undated ancestors containing dated descendants (@normal only).
    It creates an @normal with the earliest and latest dates. 
    It also creates a display date in DACS format.
    One limitation it does have is that it doesn't know about leap years, 
    so any February end date gets computed to 2/28.-->

    <!--<xsl:import href="http://www.xsltfunctions.com/xsl/functx-1.0-doc-2007-01.xsl"/>-->
    <!-- disabled because functx was unavailable just when I wanted to run this. -->
    
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
            "
        />
    </xsl:function>

    <xsl:function name="functx:repeat-string" as="xs:string" xmlns:functx="http://www.functx.com">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        <xsl:sequence
            select=" 
            string-join((for $i in 1 to $count return $stringToRepeat),
            '')
            "
        />
    </xsl:function>

    <xsl:template match="@*|node()|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()|processing-instruction()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template
        match="ead:unitdate[matches(., '^undated$') and ../../descendant::ead:c/ead:did/ead:unitdate[@normal]]">

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
                        <xsl:value-of select="substring-before(substring-after(., '-'), '/')"/>
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
                        <xsl:variable name="token-final" select="substring-before($token1, '-')"/>
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
                                <xsl:value-of
                                    select="functx:substring-after-last-match($token1, '-')"/>
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
                        <xsl:if
                            test="$compare-month=max($end-month) and matches($compare-month, '(0(1|3|5|7|8))|(10)|(12)')"
                            >31</xsl:if>
                        <xsl:if
                            test="$compare-month=max($end-month) and matches($compare-month, '02')"
                            >28</xsl:if>
                        <xsl:if
                            test="$compare-month=max($end-month) and matches($compare-month, '(0(4|6|9))|(11)')"
                            >30</xsl:if>
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
                                <xsl:value-of
                                    select="functx:substring-after-last-match($token1, '-')"/>
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
                        <xsl:if
                            test="$compare-month=max($end-month) and matches($compare-month, '(0(1|3|5|7|8))|(10)|(12)')"
                            >31</xsl:if>
                        <xsl:if
                            test="$compare-month=max($end-month) and matches($compare-month, '02')"
                            >28</xsl:if>
                        <xsl:if
                            test="$compare-month=max($end-month) and matches($compare-month, '(0(4|6|9))|(11)')"
                            >30</xsl:if>
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

        <xsl:variable name="start-year-string" as="xs:string*">
            <xsl:value-of select="min($start-year)"/>
        </xsl:variable>
        <xsl:variable name="end-year-string" as="xs:string*">
            <xsl:value-of select="max($end-year)"/>
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

        <unitdate>
            <xsl:variable name="start-date">
                <xsl:value-of select="min($start-year)"/>
                <xsl:for-each select="(min($start-year))">-<xsl:value-of
                        select="$start-month-string"/>
                </xsl:for-each>
                <xsl:for-each select="(min($start-month))">-<xsl:value-of select="$start-day-string"
                    />
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="end-date">
                <xsl:value-of select="max($end-year)"/>
                <xsl:for-each select="(max($end-year))">-<xsl:value-of select="$end-month-string"/>
                </xsl:for-each>
                <xsl:for-each select="(max($end-month))">-<xsl:value-of select="$end-day-string"/>
                </xsl:for-each>
            </xsl:variable>

            <xsl:attribute name="normal">
                <xsl:value-of select="$start-date"/>/<xsl:value-of select="$end-date"/>
            </xsl:attribute>
            <xsl:if test="$start-date!=$end-date">
                <xsl:attribute name="type">inclusive</xsl:attribute>
            </xsl:if>

            <!-- start date -->

            <xsl:value-of select="$start-year-string"/>

            <!-- start month -->

            <xsl:choose>
                <xsl:when
                    test="$start-year=$end-year and $start-date[matches(., '\d{4}-01-01')] 
                        and $end-date[matches(., '\d{4}-12-31')]"/>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when
                            test="$start-year!=$end-year and $start-date[matches(., '\d{4}-01-01')] 
                            and $end-date[matches(., '\d{4}-12-31')]"/>
                        <xsl:when
                            test="$start-year!=$end-year and $start-date[matches(., '\d{4}-01-01')] 
                            and $end-date[not(matches(., '\d{4}-12-31'))]"/>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="matches($start-month-string, '01')">
                                    <xsl:text> January</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="matches($start-month-string, '02')">
                                            <xsl:text> February</xsl:text>

                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="matches($start-month-string, '03')">
                                                  <xsl:text> March</xsl:text>

                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '04')">
                                                  <xsl:text> April</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '05')">
                                                  <xsl:text> May</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '06')">
                                                  <xsl:text> June</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '07')">
                                                  <xsl:text> July</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '08')">
                                                  <xsl:text> August</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '09')">
                                                  <xsl:text> September</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '10')">
                                                  <xsl:text> October</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '11')">
                                                  <xsl:text> November</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($start-month-string, '12')">
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
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:otherwise>
            </xsl:choose>

            <!-- start day -->
            <xsl:choose>
                <xsl:when test="$start-date!=$end-date">

                    <xsl:choose>
                        <xsl:when
                            test="$end-year-string=$start-year-string and $end-month-string=$start-month-string">
                            <xsl:choose>
                                <xsl:when
                                    test="$start-date[matches(., '\d{4}-\d{2}-01')] or $end-date[matches(., '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))')]">
                                    <xsl:if
                                        test="matches($start-day-string, '01') and not(matches($end-date, '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))'))">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="replace($start-day-string, '^0', '')"
                                        />
                                    </xsl:if>
                                    <xsl:if
                                        test="not(matches($start-day-string, '01')) and matches($end-date, '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))')">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="replace($start-day-string, '^0', '')"
                                        />
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="replace($start-day-string, '^0', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when
                                    test="$end-year-string=$start-year-string and $end-month-string!=$start-month-string">
                                    <xsl:choose>
                                        <xsl:when
                                            test="$start-date[matches(., '\d{4}-\d{2}-01')]"/>
                                        <xsl:otherwise>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of
                                                select="replace($start-day-string, '^0', '')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$end-year-string!=$start-year-string">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="$start-date[matches(., '\d{4}-\d{2}-01')]"/>
                                                <xsl:otherwise>
                                                  <xsl:text> </xsl:text>
                                                  <xsl:value-of
                                                  select="replace($start-day-string, '^0', '')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="replace($start-day-string, '^0', '')"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- end date -->

            <xsl:if test="$end-year-string and $end-year-string!=$start-year-string">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="$end-year-string"/>
            </xsl:if>
            
            <!-- end month -->

            <xsl:choose>
                <xsl:when
                    test="$end-year-string=$start-year-string and $start-month-string!=$end-month-string">
                    <xsl:choose>
                        <xsl:when test="$start-date[not(matches(., '\d{4}-01-01'))] and  
                            $end-date[not(matches(., '\d{4}-12-31'))]">
                            <xsl:text>-</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$start-date[matches(., '\d{4}-01-01')] and  
                                    $end-date[not(matches(., '\d{4}-12-31'))]">
                                    <xsl:text>-</xsl:text>
                                </xsl:when> 
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$start-date[not(matches(., '\d{4}-01-01'))] and  
                                            $end-date[matches(., '\d{4}-12-31')]">
                                            <xsl:text>-</xsl:text>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="matches($end-month-string, '01')">
                            <xsl:if test="$start-date[not(matches(., '\d{4}-01-01'))] and  
                                $end-date[not(matches(., '\d{4}-12-31'))]">
                            <xsl:text>January</xsl:text>
                        </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="matches($end-month-string, '02')">
                                    <xsl:text>February</xsl:text>

                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="matches($end-month-string, '03')">
                                            <xsl:text>March</xsl:text>

                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="matches($end-month-string, '04')">
                                                  <xsl:text>April</xsl:text>

                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '05')">
                                                  <xsl:text>May</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '06')">
                                                  <xsl:text>June</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '07')">
                                                  <xsl:text>July</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '08')">
                                                  <xsl:text>August</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '09')">
                                                  <xsl:text>September</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '10')">
                                                  <xsl:text>October</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '11')">
                                                  <xsl:text>November</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($end-month-string, '12' )">
                                                      <xsl:if test="$start-date[not(matches(., '\d{4}-01-01'))] and  
                                                          $end-date[not(matches(., '\d{4}-12-31'))]">
                                                  <xsl:text>December</xsl:text>
                                                      </xsl:if>
                                                      <xsl:if test="$start-date[not(matches(., '\d{4}-01-01'))] and  
                                                          $end-date[matches(., '\d{4}-12-31')]">
                                                          <xsl:text>December</xsl:text>
                                                      </xsl:if>
                                                      <xsl:if test="$start-date[matches(., '\d{4}-01-01')] and  
                                                          $end-date[not(matches(., '\d{4}-12-31'))]">
                                                          <xsl:text>December</xsl:text>
                                                      </xsl:if>
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
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$end-year-string!=$start-year-string">
                            <xsl:choose>
                                <xsl:when test="matches($end-month-string, '01')">
                                    <xsl:text> January</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="matches($end-month-string, '02')">
                                            <xsl:text> February</xsl:text>

                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="matches($end-month-string, '03')">
                                                  <xsl:text> March</xsl:text>

                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '04')">
                                                  <xsl:text> April</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '05')">
                                                  <xsl:text> May</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '06')">
                                                  <xsl:text> June</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '07')">
                                                  <xsl:text> July</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '08')">
                                                  <xsl:text> August</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '09')">
                                                  <xsl:text> September</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '10')">
                                                  <xsl:text> October</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when test="matches($end-month-string, '11')">
                                                  <xsl:text> November</xsl:text>

                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches($end-month-string, '12' ) and not(matches($end-date, '\d{4}-12-31'))">
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

                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

            <!-- end day -->
            <xsl:choose>
                <xsl:when test="$start-date!=$end-date">
                    <xsl:if
                        test="$start-date[not(matches(., '\d{4}-\d{2}-01'))] 
                        and $end-date[not(matches(., '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))'))]">
                        <xsl:choose>
                            <xsl:when
                                test="$end-year-string=$start-year-string and $end-month-string=$start-month-string and $end-day-string!=$start-day-string"
                                    >-<xsl:value-of select="replace($end-day-string, '^0', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when
                                        test="$end-year-string=$start-year-string and $end-month-string!=$start-month-string">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="replace($end-day-string, '^0', '')"/>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="$end-year-string!=$start-year-string">
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of
                                                  select="replace($end-day-string, '^0', '')"/>

                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:if
                        test="$start-date[matches(., '\d{4}-\d{2}-01')] 
                        or $end-date[matches(., '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))')]">

                        <xsl:if
                            test="$end-year-string=$start-year-string and $end-month-string=$start-month-string">
                            <xsl:if
                                test="matches($start-day-string, '01') and not(matches($end-date, '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))'))">
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="replace($end-day-string, '^0', '')"/>
                            </xsl:if>
                            <xsl:if
                                test="not(matches($start-day-string, '01')) and matches($end-date, '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))')">
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="replace($end-day-string, '^0', '')"/>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if
                            test="$end-year-string=$start-year-string and $end-month-string!=$start-month-string">
                            <xsl:choose>
                                <xsl:when
                                    test="matches($end-date, '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))')"/>
                                <xsl:otherwise>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="replace($end-day-string, '^0', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$end-year-string!=$start-year-string">
                            <xsl:choose>
                                <xsl:when
                                    test="matches($end-date, '(\d{4}-((0(1|3|5|7|8))|(10)|(12))-31)|(\d{4}-((0(4|6|9))|(11))-30)|(\d{4}-02-2(8|9))')"/>
                                <xsl:otherwise>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="replace($end-day-string, '^0', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            
<!--            <xsl:if test="../../descendant::ead:c/ead:did/ead:unitdate[@normal]">
                <xsl:text> and undated</xsl:text>
            </xsl:if>-->
        </unitdate>
    </xsl:template>



</xsl:stylesheet>
