xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;

declare variable $COLLECTION as document-node()* := collection("file:///C:/Documents and Settings/cmcallah/Desktop/FreshEAD/eads/mudd/publicpolicy");

for $ead as element() at $pos in $COLLECTION/*
let $dao := $ead//ead:dao[@xlink:href[contains(.,'.pdf')][contains(.,'Digitization')]],
$uri as xs:anyURI? := base-uri($ead),
$clean-uri as xs:string? := tokenize(string($uri),'/')[last()]
return
if ($dao) then
<collection doc='{$clean-uri}'>{$dao}</collection>
else()