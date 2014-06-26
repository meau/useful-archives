xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
(:
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";
:)

declare variable $COLLECTION as document-node()* := collection("file:///C:/Users/cmc279/Desktop/ATExport/?recurse=yes;select=*.xml");

for $i in $COLLECTION//ead:ead
let $arrangement := exists($i//ead:arrangement[2]),
$doc := base-uri($i)
return
<doc>
<uri>{$doc}</uri>
<arrangement>{$arrangement}</arrangement>
</doc>