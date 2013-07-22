xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";

declare copy-namespaces no-preserve, inherit;

declare variable $COLLECTION as document-node()* := collection("file:///C:/Documents and Settings/cmcallah/Desktop/FreshEAD/eads/mudd/publicpolicy");

for $ead as element() at $pos in $COLLECTION/*
let $appraisal := $ead//ead:appraisal/ead:p,
$uri as xs:anyURI? := base-uri($ead),
$clean-uri as xs:string? := tokenize(string($uri),'/')[last()]
return
if ($appraisal) then
<data doc='{$clean-uri}'>{$appraisal}</data>
else()