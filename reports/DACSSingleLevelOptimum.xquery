xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Desktop/eads/tamwag/?select=*.xml");

for $i in $COLLECTION//ead:ead
let $referencecode := $i//ead:archdesc/ead:did/ead:unitid/text(),
$repository := $i//ead:archdesc/ead:did/ead:repository/ead:corpname/text(),
$title := $i//ead:archdesc/ead:did/ead:unittitle/text(),
$date := $i//ead:archdesc/ead:did/ead:unitdate/text(),
$nonormal := count($i//ead:dsc//ead:unitdate[not(@normal)]),
$undated := count($i//ead:dsc//ead:unitdate[. eq 'undated']),
$totalnodates := count($i//ead:dsc[not(//ead:unitdate)]),
$totalcomponents:= count($i//ead:c | $i//ead:c01 | $i//ead:c02 | $i//ead:c03 | $i//ead:c04 | $i//ead:c05 | $i//ead:c06 | $i//ead:c07 | $i//ead:c08),
$extent1 := $i//ead:archdesc/ead:did/ead:physdesc/ead:extent[1]/text(),
$extent2 := $i//ead:archdesc/ead:did/ead:physdesc/ead:extent[2]/text(),
$creator := $i//ead:archdesc/ead:did/ead:origination//text(),
$scopecontent := $i//ead:archdesc/contains(.,ead:scopecontent[1]),
$bioghist := $i//ead:archdesc/contains(.,ead:bioghist[1]),
$accessrestrict := $i//ead:archdesc/ead:accessrestrict/ead:p/text(),
$userestrict := $i//ead:archdesc/ead:userestrict/ead:p/text(),
$physloc := $i//ead:archdesc/ead:did/ead:physloc/text(),
$langmaterial := $i//ead:archdesc/ead:did/ead:langmaterial/text(),
$controlaccess := $i//ead:archdesc/contains(.,ead:controlaccess),
$doc := base-uri($i),
$datemodified := $i//ead:profiledesc/ead:creation/ead:date/node(),
$totalseriesorsub := count($i//ead:*[contains(@level,'series')]),
$seriessubscopecontent := count($i//ead:*[contains(@level,'series')]/ead:scopecontent)
return
<doc>
<file>{$doc}</file>
<unitid>{$referencecode}</unitid>
<repository>{$repository}</repository>
<physloc>{$physloc}</physloc>
<title>{$title}</title>
<unitdate>{$date}</unitdate>
<extent1>{$extent1}</extent1>
<extent2>{$extent2}</extent2>
<creator>{$creator}</creator>
<scopecontent>{$scopecontent}</scopecontent>
<bioghist>{$bioghist}</bioghist>
<accessrestrict>{$accessrestrict}</accessrestrict>
<userestrict>{$userestrict}</userestrict>
<langmaterial>{$langmaterial}</langmaterial>
<controlaccess>{$controlaccess}</controlaccess>
<modified>{$datemodified}</modified>
<nonormal>{$nonormal}</nonormal>
<undated>{$undated}</undated>
<nodate>{$totalnodates}</nodate>
<totalcomponents>{$totalcomponents}</totalcomponents>
<seriesscopecontent>{$seriessubscopecontent}</seriesscopecontent>
<seriesorsub>{$totalseriesorsub}</seriesorsub>
</doc>
