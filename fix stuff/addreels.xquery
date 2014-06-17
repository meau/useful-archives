xquery version "1.0";


declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $FILE as document-node()* := doc("mssa.ms0690recon.xml");

for $container in $FILE//ead:c/ead:did/ead:container[@type eq "Box"]
let $inside-did := $container/parent::ead:did,
$reelnum := 7
return
if ($container = "8")
then
insert node
<container type="Reel">{$reelnum}</container>
as last into $inside-did
else()