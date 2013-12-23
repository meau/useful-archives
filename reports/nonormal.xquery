xquery version "1.0";


declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $COLLECTION as document-node()* := collection("file:///Users/staff/Desktop/eads/tamwag/?select=*.xml");

for $i in $COLLECTION//ead:ead
let $nonormal := count($i//ead:dsc//ead:unitdate[not(@normal)]),
$undated := count($i//ead:dsc//ead:unitdate[. eq 'undated']),
$totaldates := count($i//ead:dsc//ead:unitdate),
$doc := $i//ead:archdesc/ead:did/ead:unitid/text(),
$totalseriesorsub := count($i//ead:c[@level='series'] | $i//ead:c[@level='subseries']),
$seriessubscopecontent := count($i//ead:c[@level='series']/ead:scopecontent | $i//ead:c[@level='subseries']/ead:scopecontent)
return
<doc>
<findingaid>{$doc} </findingaid>
<nonormal>{$nonormal} / {$totaldates}</nonormal>
<undated>{$undated} / {$totaldates}</undated>
<seriesscopecontent>{$seriessubscopecontent} / {$totalseriesorsub}</seriesscopecontent>
</doc>