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

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Remove leading and trailing spaces and punctuation if unittitle contains nothing but one text()-->
        <xsl:template
        match="ead:unittitle[count(text())=1 and not(ead:emph) and (matches(text(), '[\p{Z}\p{Ps}\.,;:-]+$') or matches(text(), '^[\p{Z}\p{Pe}\?!,;:-]+'))]">
        <xsl:copy>
            <xsl:choose>
                <xsl:when
                    test="matches(text(), '^[\p{Z}\p{Pe}\?!,;:-]+') and not(matches(text(), '[\p{Z}\p{Ps}\.,;:-]+$'))">
                    <xsl:value-of select="replace(text(), '(^[\p{Z}\p{Pe}\?!,;:-]+)(.*)', '$2')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when
                            test="matches(text(), '[\p{Z}\p{Ps}\.,;:-]+$') and not(matches(text(), '^[\p{Z}\p{Pe}\?!,;:-]+'))">
                            <xsl:choose>
                                <xsl:when
                                    test="matches(text(), '[\s\.]\p{L}{1,3}\.\s*$') 
                                    or matches(text(), '\smisc\.$', 'i')
                                    or matches(text(), '\sassc\.$', 'i')
                                    or matches(text(), '\scont\.$', 'i')
                                    or matches(text(), '\sibid\.$', 'i')
                                    or matches(text(), '\svols\.$', 'i')
                                    or matches(text(), '\sincl\.$', 'i')
                                    or matches(text(), '\smats\.$', 'i')">
                                    <xsl:value-of select="normalize-space(current())"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="replace(text(), '(.*?)([\p{Z}|\p{Ps}|\.|,|;|:|-]+$)', '$1')"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when
                                    test="text()[matches(., '[\p{Z}\p{Ps}\.,;:-]+$') and matches(., '^[\p{Z}\p{Pe}\?!,;:-]+')]">
                                    <xsl:choose>
                                        <xsl:when
                                            test="matches(text(), '[\s\.]\p{L}{1,3}\.\s*$') 
                                            or matches(text(), '\smisc\.$', 'i')
                                            or matches(text(), '\sassc\.$', 'i')
                                            or matches(text(), '\scont\.$', 'i')
                                            or matches(text(), '\sibid\.$', 'i')
                                            or matches(text(), '\svols\.$', 'i')
                                            or matches(text(), '\sincl\.$', 'i')
                                            or matches(text(), '\smats\.$', 'i')">
                                            <xsl:value-of
                                                select="replace(text(), '(^[\p{Z}\p{Pe}\?!,;:-]+)(.*)', '$2')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:variable name="normalized-content">
                                                <xsl:analyze-string select="current()"
                                                  regex="(^[\p{{Z}}\p{{Pe}}\?!,;:-]+)(.+?)([\p{{Z}}\p{{Ps}}\.,;:-]+$)">
                                                  <xsl:matching-substring>
                                                  <xsl:value-of select="regex-group(2)"/>
                                                  </xsl:matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:variable>
                                            <xsl:value-of select="$normalized-content"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!-- If unittitle is mixed and ends in text, remove trailing space and select trailing punctuation from text-->
        <xsl:template
        match="text()[parent::ead:unittitle and (preceding-sibling::ead:emph or preceding-sibling::text()) and not(following-sibling::ead:emph or following-sibling::text()[matches(., '^[\p{Z}]+$')]) and (matches(string(), '[\p{Z}\p{Ps}\.,;:-]+$'))]">
        <xsl:choose>
            <xsl:when
                test="matches(current(), '[\s\.]\p{L}{1,3}\.\s*$') 
                or matches(current(), '\smisc\.$', 'i')
                or matches(current(), '\sassc\.$', 'i')
                or matches(current(), '\scont\.$', 'i')
                or matches(current(), '\sibid\.$', 'i')
                or matches(current(), '\svols\.$', 'i')
                or matches(current(), '\sincl\.$', 'i')
                or matches(current(), '\smats\.$', 'i')">
                <xsl:value-of select="replace(current(), '(^[\p{Z}\p{Pe}\?!,;:-]+)(.*)', '$2')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="matches(current(), '\.\p{Z}*$')">
                        <xsl:value-of select="replace(current(), '(.*?)(\.\p{Z}*$)', '$1')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="matches(current(), '[\p{Z}\p{Ps},;:-]+$')">
                                <xsl:analyze-string select="current()"
                                    regex="[\p{{Z}}\p{{Ps}},;:-]+$">
                                    <xsl:non-matching-substring>
                                        <xsl:value-of select="current()"/>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- If unittitle is mixed and starts with text, remove leading space and select leading punctuation from text-->
        <xsl:template
        match="text()[parent::ead:unittitle and (following-sibling::ead:emph or following-sibling::text()) and not(preceding-sibling::ead:emph or preceding-sibling::text()) and matches(string(), '^[\p{Z}\p{Pe}\?!,;:-]+')]">
        <xsl:analyze-string select="current()" regex="^[\p{{Z}}\p{{Pe}}\?!,;:-]+">
            <xsl:non-matching-substring>
                <xsl:copy-of select="current()"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <!-- mixed content; unittitle ends in emph and emph ends in punctuation or spaces (possibly followed by text with spaces/punctuation)-->
    <xsl:template
        match="ead:emph[parent::ead:unittitle and (preceding-sibling::ead:emph or preceding-sibling::text()) and not(following-sibling::ead:emph or following-sibling::text()[not(matches(., '^[\p{Z}\p{Ps}\.,;:-]+$'))]) and matches(string(), '[\p{Z}\p{Ps}\.,;:-]+$')]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="matches(current(), '\.\p{Z}*$')">
                    <xsl:choose>
                        <xsl:when
                            test="matches(current(), '[\s\.]\p{L}{1,3}\.\s*$') 
                                            or matches(current(), '\smisc\.$', 'i')
                                            or matches(current(), '\sassc\.$', 'i')
                                            or matches(current(), '\scont\.$', 'i')
                                            or matches(current(), '\sibid\.$', 'i')
                                            or matches(current(), '\svols\.$', 'i')
                                            or matches(current(), '\sincl\.$', 'i')
                                            or matches(current(), '\smats\.$', 'i')">
                            <xsl:value-of select="normalize-space(current())"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="normalize-space(replace(current(), '(.*?)(\.\p{Z}*$)', '$1'))"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches(current(), '[\p{Z}\p{Ps},;:-]+$')">
                            <xsl:analyze-string select="current()" regex="[\p{{Z}}\p{{Ps}},;:-]+$">
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="normalize-space(current())"/>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <!-- Mixed content; unittitle starts with emph and emph starts with space/punctuation -->
    <xsl:template
        match="ead:emph[parent::ead:unittitle and not(preceding-sibling::ead:emph or preceding-sibling::text()[not(matches(., '^[\p{Z}\p{Ps}\.,;:-]+$'))]) and (following-sibling::ead:emph or following-sibling::text()[not(matches(., '^[\p{Z}\p{Ps}\.,;:-]+$'))]) and matches(string(), '^[\p{Z}\p{Ps}\.,;:-]+')]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="normalize-space(current())"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- nothing before or after emph, but spaces/punctuation inside emph -->
    <xsl:template
        match="ead:emph[parent::ead:unittitle and (not(preceding-sibling::ead:emph or preceding-sibling::text())) and not(following-sibling::ead:emph or following-sibling::text()[not(matches(., '^[\p{Z}\p{Ps}\.,;:-]+$'))]) and matches(string(), '[\p{Z}\p{Ps}\.,;:-]+$')]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="matches(current(), '\.\p{Z}*$')">
                    <xsl:choose>
                        <xsl:when
                            test="matches(current(), '[\s\.]\p{L}{1,3}\.\s*$') 
                            or matches(current(), '\smisc\.$', 'i')
                            or matches(current(), '\sassc\.$', 'i')
                            or matches(current(), '\scont\.$', 'i')
                            or matches(current(), '\sibid\.$', 'i')
                            or matches(current(), '\svols\.$', 'i')
                            or matches(current(), '\sincl\.$', 'i')
                            or matches(current(), '\smats\.$', 'i')">
                            <xsl:value-of select="normalize-space(current())"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="normalize-space(replace(current(), '(.*?)(\.\p{Z}*$)', '$1'))"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches(current(), '[\p{Z}\p{Ps},;:-]+$')">
                            <xsl:analyze-string select="current()" regex="[\p{{Z}}\p{{Ps}},;:-]+$">
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="normalize-space(current())"/>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
