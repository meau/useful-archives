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
     let $folder := $ead//ead:container[@type="Folder"][matches(.,'^[0-9]+$')]
     let $maxfolder := max($folder)
     return 
     $maxfolder
   }
   
   </document>
}
</foldernum>