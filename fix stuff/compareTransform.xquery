xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
(:
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";
:)

declare variable $COLLECTION as document-node()* := collection("file:///C:/Users/cmc279/Desktop/Up2DateEAD/?recurse=yes;select=*.xml");

for $i in $COLLECTION//ead:ead
let $arrangement := count($i//ead:arrangement),
$c := $i//ead:c | $i//ead:c01 | $i//ead:c02 | $i//ead:c03 | $i//ead:c04 | $i//ead:c05 | $i//ead:c06 | $i//ead:c07 | $i//ead:c08 | $i//ead:c09 | $i//ead:c10 | $i//ead:c11 | $i//ead:c12,
$components := count($c),
$titles := count($i//ead:title),
$doc := base-uri($i),
$eadid := $i/@id
return
<doc>
<uri>{$doc}</uri>
<eadid>{$eadid}</eadid>
<arrangement>{$arrangement}</arrangement>
<components>{$components}</components>
<titles>{$titles}</titles>
</doc>