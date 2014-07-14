xquery version "1.0";
 
declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

<foldernum>
{
   for $ead in ead:ead
   let $doc := base-uri($ead)
  return
   <document uri="{$doc}">
   {
     for $ead in $ead
     let $folder := $ead//ead:container[@type="Folder"]
     let $maxfolder := max($folder)
     where matches($folder, '^[0-9]+$')
     return 
     $maxfolder
   }
   
   </document>
}
</foldernum>