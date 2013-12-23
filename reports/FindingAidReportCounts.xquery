xquery version "1.0";


declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Desktop/eads/archives/?select=*.xml");

for $i in $COLLECTION//ead:ead
let $nonormal := count($i//ead:dsc//ead:unitdate[not(@normal)]),
$undated := count($i//ead:dsc//ead:unitdate[. eq 'undated']),
$totalnodates := count($i//ead:dsc//ead:c[not(//ead:unitdate)]),
$totalcomponents:=count($i//ead:c | $i//ead:c01 | $i//ead:c02 | $i//ead:c03 | $i//ead:c04 | $i//ead:c05 | $i//ead:c06 | $i//ead:c07),
$doc := $i//ead:archdesc/ead:did/ead:unitid/text(),
$totalseriesorsub := count($i//ead:*[contains(@level,'series')]),
$seriessubscopecontent := count($i//ead:*[contains(@level,'series')]/ead:scopecontent)
return
<doc>
<findingaid>{$doc} </findingaid>
<nonormal>{$nonormal}</nonormal>
<undated>{$undated}</undated>
<nodate>{$totalnodates}</nodate>
<totalcomponents>{$totalcomponents}</totalcomponents>
<seriesscopecontent>{$seriessubscopecontent} / {$totalseriesorsub}</seriesscopecontent>
</doc>