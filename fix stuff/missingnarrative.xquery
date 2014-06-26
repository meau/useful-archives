xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $COLLECTION as document-node()* := collection("file:///C:/Users/cmc279/Desktop/Up2DateEAD/?select=*.xml");

for $i in $COLLECTION//ead:ead
let $doc := base-uri($i),
$bioghistOver := $i//ead:archdesc/ead:bioghist[@id = "biogOver"]//text()/normalize-space(.),
$bioghistFull := $i//ead:archdesc/ead:bioghist[@id = "biogFull"]//text()/normalize-space(.),
$scopecontent := $i//ead:archdesc/ead:scopecontent//text()/normalize-space(.),
$countBioghistOver := string-length($bioghistOver),
$countBioghistFull := string-length($bioghistFull),
$countScopecontent := string-length($scopecontent)
return
<root>
<doc>{$doc}</doc><lengthBioghistOver>{$bioghistOver}</lengthBioghistOver>
<lengthBioghistFull>{$bioghistFull}</lengthBioghistFull>
<lengthScopecontent>{$scopecontent}</lengthScopecontent>
</root>