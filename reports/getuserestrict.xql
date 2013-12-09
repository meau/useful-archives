xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";

declare copy-namespaces no-preserve, inherit;

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Documents/FindingAids/tamwagead");

for $ead as element() at $pos in $COLLECTION/*
let $userestrict := $ead//ead:userestrict/ead:p/text(),
$uri as xs:anyURI? := base-uri($ead),
$clean-uri as xs:string? := tokenize(string($uri),'/')[last()]
return
if ($userestrict) then
<data doc='{$clean-uri}'>{$userestrict}</data>
else()