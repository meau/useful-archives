xquery version "1.0";


declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $FILE as document-node()* := doc("reportOneOh.xml");
for $root in $FILE//root
let $doc := $root/doc,
$countBioghistOver := string-length($root/lengthBioghistOver),
$countBioghistFull := string-length($root/lengthBioghistFull),
$countScopecontent := string-length($root/lengthScopecontent)
return
<root>
<doc>{$doc}</doc>
<over>{$countBioghistOver}</over>
<full>{$countBioghistFull}</full>
<scopecontent>{$countScopecontent}</scopecontent>
</root>