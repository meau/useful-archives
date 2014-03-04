xquery version "1.0";


declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Documents/dlts_findingaids_eads/tamwag/?recurse=yes;select=*.xml");

for $i in $COLLECTION//ead:eadid
let $callno := $i/ancestor::ead:ead//ead:archdesc/ead:did/ead:unitid,
$doc := base-uri($i),
$datemodified := $i/ancestor::ead:ead//ead:profiledesc/ead:creation/ead:date
return
<doc>
<file>{$doc}</file>
{$i}
{$callno}
{$datemodified}
</doc>