xquery version "1.0";


declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Documents/FindingAids/univarchives");

for $i in $COLLECTION//ead:ead
let $referencecode := $i//ead:archdesc/ead:did/ead:unitid/text(),
$repository := $i//ead:archdesc/ead:did/ead:repository/ead:corpname/text(),
$title := $i//ead:archdesc/ead:did/ead:unittitle/text(),
$date := $i//ead:archdesc/ead:did/ead:unitdate/text(),
$extent := $i//ead:archdesc/ead:did/ead:physdesc/ead:extent,
$creator := $i//ead:archdesc/ead:did/ead:origination//text(),
$scopecontent := $i//ead:archdesc/contains(.,ead:scopecontent[1]),
$bioghist := $i//ead:archdesc/contains(.,ead:bioghist[1]),
$accessrestrict := $i//ead:archdesc/ead:accessrestrict/ead:p/text(),
$physloc := $i//ead:archdesc/ead:did/ead:physloc/text(),
$langmaterial := $i//ead:archdesc/ead:did/ead:langmaterial/text(),
$controlaccess := $i//ead:archdesc/contains(.,ead:controlaccess),
$doc := base-uri($i),
$datemodified := $i//ead:profiledesc/ead:creation/ead:date/node()
return
<doc>
<file>{$doc}</file>
<unitid>{$referencecode}</unitid>
<repository>{$repository}</repository>
<physloc>{$physloc}</physloc>
<title>{$title}</title>
<unitdate>{$date}</unitdate>
{$extent}
<creator>{$creator}</creator>
<scopecontent>{$scopecontent}</scopecontent>
<bioghist>{$bioghist}</bioghist>
<accessrestrict>{$accessrestrict}</accessrestrict>
<langmaterial>{$langmaterial}</langmaterial>
<controlaccess>{$controlaccess}</controlaccess>
<modified>{$datemodified}</modified>
</doc>
