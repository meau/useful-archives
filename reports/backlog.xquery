xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
(:
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";
:)

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Desktop/tamwagFinalGen/?recurse=yes;select=*.xml");

for $seriestitle in $COLLECTION//ead:*[contains(@level,'series')]/ead:did/ead:unittitle//text()
let 
$series := $seriestitle/ancestor::ead:*[contains(@level,'series')],
$i := $series/ancestor::ead:ead,
$referencecode := $i//ead:archdesc/ead:did/ead:unitid//text(),
$title := $i//ead:archdesc/ead:did/ead:unittitle//text(),
$date := $i//ead:archdesc/ead:did/ead:unitdate/text(),
$c := $i//ead:c | $i//ead:c01 | $i//ead:c02 | $i//ead:c03 | $i//ead:c04 | $i//ead:c05 | $i//ead:c06 | $i//ead:c07 | $i//ead:c08,
$extent1 := $i//ead:archdesc/ead:did/ead:physdesc/ead:extent[1]//text(),
$extent2 := $i//ead:archdesc/ead:did/ead:physdesc/ead:extent[2]//text(),
$doc := base-uri($i),
$datemodified := $i//ead:profiledesc/ead:creation/ead:date/node(),
$unprocessedfootage := distinct-values($series//ead:container[@type eq 'Box'])
where $seriestitle[contains(lower-case(.),'unprocessed')]
order by $referencecode
return
<doc>
<file>{$doc}</file>
<unitid>{$referencecode}</unitid>
<title>{$title}</title>
<extent1>{$extent1}</extent1>
<extent2>{$extent2}</extent2>
<modified>{$datemodified}</modified>
<unprocessed>{$seriestitle}</unprocessed>
<footage>{$unprocessedfootage}</footage>
</doc>
