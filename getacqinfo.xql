xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";

declare copy-namespaces no-preserve, inherit;

declare variable $COLLECTION as document-node()* := collection("file:///C:/Documents and Settings/cmcallah/Desktop/FreshEAD/eads/mudd/publicpolicy");

for $ead as element() at $pos in $COLLECTION/*
let $acqinfo := $ead//ead:acqinfo/ead:p,
$uri as xs:anyURI? := base-uri($ead),
$clean-uri as xs:string? := tokenize(string($uri),'/')[last()]
return
if ($acqinfo) then
<data doc='{$clean-uri}'>{$acqinfo}</data>
else()