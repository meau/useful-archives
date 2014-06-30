xquery version "1.0";

(:declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";:)

import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $COLLECTION as document-node()* := collection("C:/Users/cmc279/Desktop/EADOneOh");

for $i in $COLLECTION//ead
let $doc := base-uri($i),
$bioghistOver := $i//archdesc/bioghist[@id = "biogOver"]//text()/normalize-space(.),
$bioghistFull := $i//archdesc/bioghist[@id = "biogFull"]//text()/normalize-space(.),
$scopecontent := $i//archdesc/scopecontent//text()/normalize-space(.)
return
<root>
<doc>{$doc}</doc><lengthBioghistOver>{$bioghistOver}</lengthBioghistOver>
<lengthBioghistFull>{$bioghistFull}</lengthBioghistFull>
<lengthScopecontent>{$scopecontent}</lengthScopecontent>
</root>