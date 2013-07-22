<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:import href="MARC21slimUtils.xsl"/>
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="marc:record">
		<?filetitle?>
		<ead xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="urn:isbn:1-931666-22-9" audience="external" xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd">
			<!--The following section is header information for web display of the finding aid-->
			<eadheader countryencoding="iso3166-1" dateencoding="iso8601" langencoding="iso-639-2b" relatedencoding="Dublin Core" repositoryencoding="iso15511" scriptencoding="iso15924">
				<eadid countrycode="US" encodinganalog="dc:identifier" mainagencycode="US-NjP" 
					url="http://arks.princeton.edu/ark:INSERT_ARK_HERE" 
					urn="ark:INSERT_ARK_HERE">{{{{  INSERT Call Number HERE  }}}}</eadid>
				<filedesc>
					<titlestmt>
						<xsl:for-each select="marc:datafield[@tag=245]">
							<titleproper encodinganalog="dc:title">
								<!--<xsl:value-of select="marc:subfield[@code='a']"/>-->
								<xsl:value-of select="marc:subfield[@code='a']"/>
								<xsl:text> </xsl:text>
								<date normal="YYYY/YYYY" type="inclusive">
									<xsl:value-of select="marc:subfield[@code='f']"/>
								</date>
								<xsl:if test="marc:subfield[@code='g']!=''">
									<xsl:text> (bulk </xsl:text>
									<date normal="YYYY/YYYY" type="bulk">
										<xsl:variable name="date">
											<xsl:value-of select="substring-before(substring-after(marc:subfield[@code='g'], '(bulk '), ')')"/>
										</xsl:variable>
										<xsl:value-of select="$date"/>
									</date>
									<xsl:text>)</xsl:text>
								</xsl:if>
								<!--<xsl:if test="marc:subfield[@code='g']!=''">
									<date normal="YYYY/YYYY" type="bulk">
										<xsl:text> </xsl:text>
										<xsl:value-of select="marc:subfield[@code='g']"/>
									</date>
								</xsl:if>-->
								
							</titleproper>
						</xsl:for-each>
					</titlestmt>
					<!--	<author encodinganalog="Creator">Finding aid prepared by MarcEdit</author> -->
					<publicationstmt>
						<publisher encodinganalog="dc:publisher">Princeton University Library. Department of Rare Books and Special Collections.</publisher>
						<address>
							<addressline>Seeley G. Mudd Manuscript Library</addressline>
							<addressline>65 Olden Street</addressline>
							<addressline>Princeton, New Jersey 08540 USA</addressline>
							<addressline>Phone:  609-258-6345</addressline>
							<addressline>Fax:  609-258-3385</addressline>
							<addressline altrender="email">mudd@princeton.edu</addressline>
							<addressline altrender="url">http://www.princeton.edu/~mudd</addressline>
						</address>
						<date encodinganalog="dc:date" normal="2012" type="publication">Published in 2012.</date>
					</publicationstmt>
					<!-- <notestmt>
						<note encodinganalog="Description">
							<p>Funding for encoding this finding aid was provided through a grant
                                    awarded by the National Endowment for the Humanities.</p>
						</note>
					</notestmt> -->
				</filedesc>
				<profiledesc>
					<creation>Machine-readable finding aid encoded in EAD 2002 created from MARC record via MarcEdit and XSL stylesheets in <date normal="2009" type="encoder">2009</date>.</creation>
					<langusage>Finding aid written in <language encodinganalog="dc:language" langcode="eng">English</language>.</langusage>
					<descrules>Finding aid content adheres to that prescribed by <emph render="italic">
							<expan abbr="dacs" altrender="MARC">Describing Archives: A Content Standard</expan>.</emph>
					</descrules>
				</profiledesc>
			</eadheader>
			<archdesc level="collection" relatedencoding="marc21" type="inventory">
				<did>
					<head>Summary Information</head>
					<repository id="publicpolicy" encodinganalog="852$a" label="Location: ">
						<corpname>Princeton University Library. Department of Rare Books and Special Collections.</corpname>
						<subarea>Seeley G. Mudd Manuscript Library.</subarea>
						<subarea>Public Policy Papers.</subarea>
						<!-- <subarea>Princeton University Archives.</subarea> -->
						<address>
							<addressline>65 Olden Street</addressline>
							<addressline>Princeton, New Jersey 08540 USA</addressline>
						</address>
					</repository>
					<unitid label="Call number: " countrycode="US" encodinganalog="084$a" repositorycode="US-NjP" type="collection">
						<xsl:text>{{{{  INSERT Call Number HERE  }}}}</xsl:text>
					</unitid>
					<xsl:if test="marc:datafield[@tag=100]">
						<xsl:for-each select="marc:datafield[@tag=100]">
							<origination label="Creator: ">
								<persname encodinganalog="100" source="lcnaf" role="creator" rules="dacs">
									<xsl:for-each select="marc:subfield">
										<xsl:value-of select=". "/>
										<xsl:if test="position()!=last()">
											<xsl:text> </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</persname>
							</origination>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="marc:datafield[@tag=110]">
						<xsl:for-each select="marc:datafield[@tag=110]">
							<origination label="Creator: ">
								<corpname encodinganalog="110" source="lcnaf" role="creator" rules="dacs">
									<xsl:for-each select="marc:subfield">
										<xsl:value-of select=". "/>
										<xsl:if test="position()!=last()">
											<xsl:text> </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</corpname>
							</origination>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="marc:datafield[@tag=111]">
						<xsl:for-each select="marc:datafield[@tag=111]">
							<origination label="Creator: ">
								<corpname encodinganalog="111" source="lcnaf" role="creator" rules="dacs">
									<xsl:value-of select="."/>
								</corpname>
							</origination>
						</xsl:for-each>
					</xsl:if>
					<xsl:for-each select="marc:datafield[@tag=245]">
						<unittitle encodinganalog="245$a" label="Title: ">
							<xsl:value-of select="marc:subfield[@code='a']"/>
							<xsl:text> </xsl:text>
							
						</unittitle>
						<unitdate encodinganalog="245$f" normal="YYYY/YYYY" type="inclusive">
							<xsl:value-of select="marc:subfield[@code='f']"/>
						</unitdate>
						<xsl:if test="marc:subfield[@code='g']!=''">
							<xsl:text> (bulk </xsl:text>
							<unitdate encodinganalog="245$g" normal="YYYY/YYYY" type="bulk">
								<xsl:variable name="date">
									<xsl:value-of select="substring-before(substring-after(marc:subfield[@code='g'], '(bulk '), ')')"/>
								</xsl:variable>
								<xsl:value-of select="$date"/>
							</unitdate>
							<xsl:text>)</xsl:text>
						</xsl:if>
						<!-- <xsl:for-each select="marc:datafield[@tag=245]">
					<unittitle encodinganalog="245$a" label="Title and dates: ">
						<xsl:value-of select="marc:subfield[@code='a']"/>
					</unittitle>
					<xsl:if test="marc:subfield[@code='f']!=''">
						<unitdate type="inclusive" encodinganalog="245$f">
							<xsl:value-of select="marc:subfield[@code='f']"/>
						</unitdate>
					</xsl:if> -->
					</xsl:for-each>
					<xsl:if test="marc:datafield[@tag=300]">
						<xsl:for-each select="marc:datafield[@tag=300]">
							<physdesc label="Size: ">
								<extent encodinganalog="300$a">
									<xsl:for-each select="marc:subfield">
										<xsl:value-of select=". "/>
										<xsl:if test="position()!=last()">
											<xsl:text> </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</extent>
							</physdesc>
						</xsl:for-each>
					</xsl:if>
					<xsl:for-each select="marc:datafield[@tag=254]">
						<materialspec encodinganalog="254">
							<xsl:value-of select="."/>
						</materialspec>
					</xsl:for-each>
					<!--				
<xsl:for-each select="marc:datafield[@tag=520]">
					<xsl:if test="marc:datafield[@tag=520][@ind1=' '] | marc:datafield[@tag=520][@ind1='']">
						<abstract encodinganalog="520$a">
							<xsl:value-of select="marc:subfield[@code='a']" />
						</abstract>
					</xsl:if>
					<xsl:if test="marc:datafield[@tag=520][@ind1='3']">
						<abstract encodinganalog="5203_">
							<xsl:value-of select="marc:subfield[@code='a']" />
						</abstract>
					</xsl:if>
					<xsl:if test="marc:datafield[@tag=520][@ind1='2']">
						<scopecontent encodinganalog="5202_" id="a3">
							<xsl:value-of select="marc:subfield[@code='a']" />
						</scopecontent>
					</xsl:if>
				</xsl:for-each>

					Error - Added an empty <physloc> element: 
					
					<xsl:if test="marc:datafield[@tag=852]">
					<xsl:for-each select="marc:datafield[@tag=852]">
						<physloc encodinganalog="852$z">
							<xsl:value-of select="marc:subfield[@code='z']"/>
						</physloc>
					</xsl:for-each>
					</xsl:if>
					
					-->
					<langmaterial encodinganalog="546$a" label="Language(s) of material: ">
						<xsl:if test="marc:datafield[@tag=546]">
							<language encodinganalog="041$a" langcode="eng">
								<xsl:value-of select="marc:datafield[@tag=546]"/>
							</language>
						</xsl:if>
						<xsl:if test="not(marc:datafield[@tag=546])">
							<language encodinganalog="041$a" langcode="eng"></language>
							
						</xsl:if>
					</langmaterial>
					<!--Delete or add languages as needed-->
					<abstract label="Abstract: ">{{{{  INSERT Abstract HERE  }}}}</abstract>
					<physloc type="code">mudd</physloc>
				</did>
				<bioghist encodinganalog="545$a">
					<xsl:if test="marc:datafield[@tag=545]">
						<xsl:if test="marc:datafield[@tag=545][@ind1='0']">
							<head>Biography</head>
							<dao xlink:title="Princeton University Shield" xlink:href="bioghist-images/shieldlogo.jpg"/>
							<xsl:for-each select="marc:datafield[@tag=545]">
								<p>
									<xsl:value-of select="."/>
								</p>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="marc:datafield[@tag=545][@ind1='1']">
							<head>Organizational History</head>
							<dao xlink:title="Princeton University Shield" xlink:href="bioghist-images/shieldlogo.jpg"/>
							<xsl:for-each select="marc:datafield[@tag=545]">
								<p>
									<xsl:value-of select="."/>
								</p>
							</xsl:for-each>
						</xsl:if>
						
					</xsl:if>
				</bioghist>
				<descgrp id="dacs3">
					<scopecontent encodinganalog="520$a">
						<head>Description</head>
						<xsl:for-each select="marc:datafield[@tag=520]">
							<p>
								<xsl:for-each select="marc:subfield[@code='a']">
									<xsl:value-of select="."/>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code='b']">
									<xsl:text> </xsl:text>
									<xsl:value-of select="."/>
								</xsl:for-each>
							</p>
						</xsl:for-each>
					</scopecontent>
					<xsl:for-each select="marc:datafield[@tag=351]">
						<arrangement encodinganalog="351$a">
							<head>Arrangement</head>
							<p>
								<xsl:value-of select="."/>
							</p>
						</arrangement>
					</xsl:for-each>
				</descgrp>
				<!--	<xsl:if test="marc:datafield[@tag=351] and not (marc:datafield[@tag=520])">
				<descgrp id="dacs3">
					<xsl:for-each select="marc:datafield[@tag=351]">
						<arrangement encodinganalog="351" id="a4">
							<head>Arrangement</head>
							<p>
								<xsl:value-of select="."/>
							</p>
						</arrangement>
					</xsl:for-each>
				</descgrp>
			</xsl:if> -->
				<!-- <xsl:for-each select="marc:datafield[@tag=351]">
				<arrangement encodinganalog="351" id="a4">
					<head>Arrangement</head>
					<p>
						<xsl:value-of select="."/>
					</p>
				</arrangement>
			</xsl:for-each>
			<xsl:for-each select="marc:datafield[@tag=520]">
				<scopecontent encodinganalog="520" id="asc">
					<head>Description</head>
					<p>
						<xsl:value-of select="."/>
					</p>
				</scopecontent>
				
				</xsl:for-each> -->
				<descgrp id="dacs4">
					<head>Access and Use</head>
					<accessrestrict encodinganalog="506$a">
						<head>Access Restrictions</head>
						<xsl:if test="marc:datafield[@tag=506]">
							<p>
								<xsl:value-of select="marc:datafield[@tag='506']"/>
							</p>
						</xsl:if>
						<xsl:if test="not(marc:datafield[@tag='506'])">
							<p>
								<xsl:text>The collection is open for research.</xsl:text>
							</p>
						</xsl:if>
					</accessrestrict>
					<userestrict encodinganalog="540$a">
						<head>Restrictions on Use and Copyright</head>
						<xsl:if test="marc:datafield[@tag=540]">
							<p>
								<xsl:value-of select="marc:datafield[@tag='540']"/>
							</p>
						</xsl:if>
						<xsl:if test="not(marc:datafield[@tag='540'])">
							<p>
								<xsl:text>Single photocopies may be made for research purposes. Permission to publish materials from the collection must be requested from the Curator of the Public Policy Papers. Researchers are responsible for determining any copyright questions.</xsl:text>
							</p>
						</xsl:if>
					</userestrict>
					<xsl:for-each select="marc:datafield[@tag=538]">
						<phystech encodinganalog="538$a">
							<p>
								<xsl:value-of select="."/>
							</p>
						</phystech>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=555]">
						<otherfindaid encodinganalog="555$u">
							<head>Other Finding Aid(s)</head>
							<p>
								<xsl:value-of select="."/>
							</p>
						</otherfindaid>
					</xsl:for-each>
				</descgrp>
				<xsl:if test="marc:datafield[@tag=541] or marc:datafield[@tag=561]">
					<descgrp id="dacs5">
						<head>Acquisition and Appraisal</head>
						<xsl:for-each select="marc:datafield[@tag=561]">
							<custodhist encodinganalog="561$a">
								<head>Custodial History</head>
								<p>
									<xsl:value-of select="."/>
								</p>
							</custodhist>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag=541]">
							<acqinfo encodinganalog="541$a">
							<head>Provenance and Acquisition</head>
								<p>
									<xsl:for-each select="marc:subfield">
										<xsl:value-of select="."/>
										<xsl:if test="position()!=last()">
											<xsl:text> </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</p>
							</acqinfo>
						</xsl:for-each>
					</descgrp>
				</xsl:if>
				<!--
			<descgrp id="dacs5">
				<head>Acquisition and Appraisal</head>
				<xsl:for-each select="marc:datafield[@tag=561]">

					<custodhist encodinganalog="561" id="a16">
						<head>Custodial History</head>
						<p>
							<xsl:value-of select="."/>
						</p>
					</custodhist>
				</xsl:for-each>
				<xsl:for-each select="marc:datafield[@tag=541]">
					<acqinfo encodinganalog="541" id="a19">

						<head>Provenance and Acquistiion</head>
						<p>
							<xsl:value-of select="."/>
						</p>
					</acqinfo>
				</xsl:for-each>
				<xsl:for-each select="marc:datafield[@tag=584]">
					<head>Accrurals</head>
					<accruals encodinganalog="584" id="a10">
						<p>
							<xsl:value-of select="."/>
						</p>
					</accruals>
				</xsl:for-each>
				</descgrp> -->
				<xsl:if test="marc:datafield[@tag=535] or marc:datafield[@tag=530] or marc:datafield[@tag=544] or marc:datafield[@tag=581]">
					<descgrp id="dacs6">
						<head>Related Materials</head>
						<xsl:for-each select="marc:datafield[@tag=535]">
							<originalsloc encodinganalog="535">
								<head>Location of Originals</head>
								<p>
									<xsl:value-of select="."/>
								</p>
							</originalsloc>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag=530]">
							<altformavail encodinganalog="530$a" id="a9">
								<head>Location of Copies or Alternate Formats</head>
								<p>
									<xsl:value-of select="."/>
								</p>
							</altformavail>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag=544]">
							<relatedmaterial encodinganalog="544$a">
								<head>Related Archival Material</head>
								<p>
									<xsl:value-of select="."/>
								</p>
							</relatedmaterial>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag=581]">
							<bibliography encodinganalog="581$a">
								<head>Publications Citing These Papers</head>
								<p>
									<xsl:value-of select="."/>
								</p>
							</bibliography>
						</xsl:for-each>
					</descgrp>
				</xsl:if>
				<!--	<descgrp id="dacs6">
				<head>Related Material</head>
				<xsl:for-each select="marc:datafield[@tag=544]">
					<relatedmaterial encodinganalog="544 1" id="a6">
						<head>Related material</head>
						<p>
							<xsl:value-of select="."/>
						</p>
					</relatedmaterial>
				</xsl:for-each>
				<xsl:for-each select="marc:datafield[@tag=530]">
					<altformavail encodinganalog="530" id="a9">
						<p>
							<xsl:value-of select="."/>
						</p>
					</altformavail>
					<xsl:for-each select="marc:datafield[@tag=535]">
						<originalsloc encodinganalog="535">
							<p>
								<xsl:value-of select="."/>
							</p>
						</originalsloc>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="marc:datafield[@tag=544]">
					<separatedmaterial encodinganalog="544 0" id="a7">
						<head>Separated Material</head>
						<p>
							<xsl:value-of select="."/>
						</p>
					</separatedmaterial>
				</xsl:for-each>
				<xsl:for-each select="marc:datafield[@tag=581]">
					<bibliography encodinganalog="581" id="a11">
						<p>
							<xsl:value-of select="."/>
						</p>
					</bibliography>
				</xsl:for-each>
				</descgrp> -->
				<descgrp id="dacs7">
					<head>Processing and Other Information</head>
					<xsl:for-each select="marc:datafield[@tag=500]">
						<note label="General Note">
							<p>
								<xsl:value-of select="."/>
							</p>
						</note>
					</xsl:for-each>
					<prefercite encodinganalog="524$a">
						<head>Preferred Citation</head>
						<p>Identification of specific item; Date (if known); (Collection Title), Box and Folder Number; Department of Rare Books and Special Collections, Princeton University Library.</p>
					</prefercite>
				</descgrp>
				<controlaccess>
					<head>Subject Headings</head>
					<p>These materials have been indexed in the <extref xlink:href="http://catalog.princeton.edu">Princeton University Library online catalog</extref> using the following terms. Those seeking related materials should search under these terms.</p>
					<xsl:for-each select="marc:datafield[@tag=600]">
						<persname encodinganalog="600" rules="dacs" source="lcnaf">
							<xsl:for-each select="marc:subfield[@code='a']">
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='b']">
								<xsl:text> </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='c']">
								<xsl:text> </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='q']">
								<xsl:text> </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='d']">
								<xsl:text> </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='t']">
								<xsl:text>. </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='v']">
								<xsl:text> -- </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='x']">
								<xsl:text> -- </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
						</persname>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=610]">
						<corpname source="lcnaf" rules="dacs" encodinganalog="610">
							<xsl:for-each select="marc:subfield">
								<xsl:value-of select="."/>
								<xsl:choose>
									<xsl:when test="(@code='a'  or @code='b') and following-sibling::*[1][@code='b']">
										<xsl:text> </xsl:text>
									</xsl:when>
									<xsl:when test="@code='a' and following-sibling::*[1][@code='t']">
										<xsl:text> </xsl:text>
									</xsl:when>
									<xsl:when test="position() = last()"/>
									<xsl:otherwise>
										<xsl:text> -- </xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</corpname>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=630]">
						<title encodinganalog="630" source="lcnaf" rules="dacs">
							<xsl:for-each select="marc:subfield">
								<xsl:value-of select="."/>
								<xsl:if test="position()!=last()">
									<xsl:text> -- </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</title>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=650]">
						<subject source="lcsh" encodinganalog="650">
							<xsl:for-each select="marc:subfield">
								<xsl:value-of select="."/>
								<xsl:if test="position()!=last()">
									<xsl:text> -- </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</subject>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=651]">
						<geogname source="lcsh" encodinganalog="651">
							<xsl:for-each select="marc:subfield">
								<xsl:value-of select="."/>
								<xsl:if test="position()!=last()">
									<xsl:text> -- </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</geogname>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=655]">
						<genreform source="aat" encodinganalog="655">
							<xsl:for-each select="marc:subfield[@code='a']">
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='z']">
								<xsl:text> -- </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='y']">
								<xsl:text> -- </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
						</genreform>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=656]">
						<genreform source="aat" encodinganalog="656">
							<xsl:for-each select="marc:subfield[@code='a']">
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='z']">
								<xsl:text> -- </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code='y']">
								<xsl:text> -- </xsl:text>
								<xsl:value-of select="."/>
							</xsl:for-each>
						</genreform>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=657]">
						<function source="aat" encodinganalog="657">
							<xsl:for-each select="marc:subfield">
								<xsl:value-of select="."/>
								<xsl:if test="position()!=last()">
									<xsl:text> -- </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</function>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=700]">
						<persname encodinganalog="700" source="lcnaf" rules="dacs">
							<xsl:for-each select="marc:subfield">
								<xsl:value-of select=". "/>
								<xsl:if test="position()!=last()">
									<xsl:text> </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</persname>
					</xsl:for-each>
					<xsl:for-each select="marc:datafield[@tag=710]">
						<corpname encodinganalog="710" source="lcnaf" rules="dacs">
							<xsl:for-each select="marc:subfield">
								<xsl:value-of select=". "/>
								<xsl:if test="position()!=last()">
									<xsl:text> </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</corpname>
					</xsl:for-each>
					<subject encodinganalog="690" source="local" authfilenumber="t00">
						<xsl:text>{{{{  INSERT local subject term (repeat if necessary) Be sure to change authfilenumber to correct code }}}}</xsl:text>
					</subject>
				</controlaccess>
			</archdesc>
		</ead>
	</xsl:template>
</xsl:stylesheet>
