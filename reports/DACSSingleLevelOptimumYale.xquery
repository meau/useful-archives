xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
(:
import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";
:)

declare variable $COLLECTION as document-node()* := collection("file:///C:/Users/cmc279/Desktop/Master_EAD2002_AT/?recurse=yes;select=*.xml");

for $i in $COLLECTION//ead:ead
let $referencecode := $i//ead:archdesc/ead:did/ead:unitid//text(),
$repository := $i//ead:archdesc/ead:did/ead:repository/ead:corpname//text(),
$title := $i//ead:archdesc/ead:did/ead:unittitle//text(),
$date := $i//ead:archdesc/ead:did/ead:unitdate/text(),
$c := $i//ead:c | $i//ead:c01 | $i//ead:c02 | $i//ead:c03 | $i//ead:c04 | $i//ead:c05 | $i//ead:c06 | $i//ead:c07 | $i//ead:c08 | $i//ead:c09 | $i//ead:c10 | $i//ead:c11 | $i//ead:c12,
$nonormal := count($c/ead:did/ead:unitdate[not(@normal)]),
$undated := count($c/ead:did/ead:unitdate[. eq 'undated']),
$dsctitle := count($c/ead:did/ead:unittitle),
$totaldates := count($c/ead:did/ead:unitdate[not(@type="bulk")]),
$totalnocontainer := count($c[not(/ead:c | /ead:c01 | /ead:c02 | /ead:c03 | /ead:c04 | /ead:c05 | /ead:c06 | /ead:c07 | /ead:c08 | /ead:c09 | /ead:c10 | /ead:c11 | /ead:c12)]/ead:did[not(//ead:container)]),
$totalcomponents:= count($c),
$totalids := count($c/@id),
$extent1 := $i//ead:archdesc/ead:did/ead:physdesc/ead:extent[1]//text(),
$extent2 := $i//ead:archdesc/ead:did/ead:physdesc/ead:extent[2]//text(),
$creator := $i//ead:archdesc/ead:did/ead:origination//text(),
$acqinfo := exists($i//ead:acqinfo),
$physloc := exists($i//ead:physloc),
$appraisal := exists($i//ead:appraisal),
$abstract := exists($i//ead:abstract),
$scopecontent := exists($i//ead:scopecontent),
$bioghist := exists($i//ead:bioghist),
$arrangement := exists($i//ead:arrangement),
$processinfo := exists($i//ead:processinfo),
$accessrestrict := $i//ead:accessrestrict/ead:p//text(),
$userestrict := $i//ead:userestrict/ead:p//text(),
$physloc := $i//ead:physloc//text(),
$langcode := $i//ead:archdesc/ead:did/ead:langmaterial/ead:language//text(),
$langmaterial := $i//ead:archdesc/ead:did/ead:langmaterial//text(),
$controlaccess := exists($i//ead:controlaccess),
$doc := base-uri($i),
$datemodified := $i//ead:revisiondesc//ead:date/node(),
$totalseriesorsub := count($i//ead:*[contains(@level,'series')]),
$seriessubscopecontent := count($i//ead:*[contains(@level,'series')]/ead:scopecontent),
$index := exists($i//ead:index)
return
<doc>
<file>{$doc}</file>
<unitid>{$referencecode}</unitid>
<repository>{$repository}</repository>
<physloc>{$physloc}</physloc>
<title>{$title}</title>
<unitdate>{$date}</unitdate>
<extent1>{$extent1}</extent1>
<extent2>{$extent2}</extent2>
<creator>{$creator}</creator>
<accessrestrict>{$accessrestrict}</accessrestrict>
<userestrict>{$userestrict}</userestrict>
<acqinfo>{$acqinfo}</acqinfo>
<appraisal>{$appraisal}</appraisal>
<abstract>{$abstract}</abstract>
<langcode>{$langcode}</langcode>
<scopecontent>{$scopecontent}</scopecontent>
<bioghist>{$bioghist}</bioghist>
<arrangement>{$arrangement}</arrangement>
<processinfo>{$processinfo}</processinfo>
<langmaterial>{$langmaterial}</langmaterial>
<controlaccess>{$controlaccess}</controlaccess>
<modified>{$datemodified}</modified>
<totalc>{$totalcomponents}</totalc>
<totalids>{$totalids}</totalids>
<nonormal>{$nonormal}</nonormal>
<undated>{$undated}</undated>
<dscdates>{$totaldates}</dscdates>
<nocontainer>{$totalnocontainer}</nocontainer>
<dsctitle>{$dsctitle}</dsctitle>
<seriesscopecontent>{$seriessubscopecontent}</seriesscopecontent>
<seriesorsub>{$totalseriesorsub}</seriesorsub>
<index>{$index}</index>
</doc>
