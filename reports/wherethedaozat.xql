xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";

declare copy-namespaces no-preserve, inherit;

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Documents/FindingAids/?recurse=yes;select=*.xml");

for $ead as element() at $pos in $COLLECTION/*
let $dao := $ead//ead:dao,
$uri as xs:anyURI? := base-uri($ead),
$clean-uri as xs:string? := tokenize(string($uri),'/')[last()]
return
if ($dao) then
<data doc='{$clean-uri}'>{$dao}</data>
else()