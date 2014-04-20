xquery version "1.0";


declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Documents/dlts_findingaids_eads/tamwag/?recurse=yes;select=*.xml");

for $i in $COLLECTION//ead:ead
let $callno := $i//ead:archdesc/ead:did/ead:unitid/text(),
$doc := base-uri($i),
$title := $i//ead:archdesc/ead:did/ead:unittitle//text()/normalize-space(),
$datemodified := $i//ead:profiledesc/ead:creation/ead:date/text()
return
<doc>

<file>{$doc}</file>
<callno>{$callno}</callno>
<title>{$title}</title>
<modified>{$datemodified}</modified>
</doc>