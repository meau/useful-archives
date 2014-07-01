xquery version "1.0";

declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare function local:change-elem-names
  ($nodes as node()*, $old-names as xs:string+,
   $new-names as xs:string+) as node()* {
  if (count($old-names) != count($new-names))
  then error(xs:QName("Different_Number_Of_Names"))
  else for $node in $nodes
       return if ($node instance of element())
              then let $newName :=
                     if (local-name($node) = $old-names)
                     then $new-names[index-of($old-names, local-name($node))]
                     else local-name($node)
                   return element {$newName}
                     {$node/@*,
                      local:change-elem-names($node/node(),
                                              $old-names, $new-names)}
              else $node
};
declare variable $COLLECTION as document-node()* := db:open('MSSAAtExport');
for $order in $COLLECTION/ead:ead
let $oldNames := ("c01", "c02", "c03", "c04", "c05", "c06", "c07", "c08", "c09", "c10", "c11", "c12")
let $newNames := ("c","c","c","c","c","c","c","c","c","c","c","c")
return local:change-elem-names($order, $oldNames, $newNames)