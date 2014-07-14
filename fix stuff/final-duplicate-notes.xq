xquery version "3.0";
 
declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
 
<dupes>
  {
  for $ead in ead:ead
  let $doc := base-uri($ead)
  return
   <document uri="{$doc}">
     {
    for $note in $ead//ead:dsc//ead:note
    let $parent-notes := $note/parent::ead:*/parent::ead:*/ead:note
      for $p in $parent-notes
      let $xpath := replace(path($p),'\[1\]','')
      let $xpathNS := replace($xpath, 'Q\{urn:isbn:1-931666-22-9\}', 'ead:')
      let $duplicate-test := deep-equal(normalize-space($note), normalize-space($p))
      return
             <note duplicate-parent="{$duplicate-test}">
             {
               if ($duplicate-test eq true()) 
               then element {'path-to-parent'} {$xpathNS}
               else ()
             }
    </note>
    }
  </document>
}
</dupes>