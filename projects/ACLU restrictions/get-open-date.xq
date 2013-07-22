xquery version "1.0";

module namespace local = 'local.uri';

declare function local:get-open-date( $norm as xs:string?, $series as xs:integer?, $current-year as xs:integer? ) as xs:string? {  
(: 
  $norm is normalized date in ead:unitdate/@normal, which may be in any of the following formats:
    YYYY/YYYY
    YYYY-MM/YYYY-MM
    YYYY-MM-DD/YYYY-MM-DD
    YYYY-MM-DD/YYYY-MM
    YYYY-MM/YYYY-MM-DD
    YYYY-MM
    YYYY-MM-DD
    YYYY
:)

(:---------------------------------------------------------------------------------
 
This isn't quite right yet. I think we need for empties to inherit from parents and then treated as $year
I'm still trying to figure this out and I'm sure my syntax is crazy wrong, but something like
if ($norm eq ' ') then
let $parent := $year

 and parent is ancestor::ead:c/ead:did/ead:unitdate/@normal
 
 :--------------------------------------------------------------------------------:)

(:---------------------------------------------------------------------------------
 : then first process dates with months (days don't matter) YYYY-MM[-DD]
 :--------------------------------------------------------------------------------:)
 if (contains($norm, "-")) then (
      let $tokens := tokenize($norm,'-'),
      $year := number($tokens[1]),
      $month := number($tokens[2]),
      $year30 := $year+30,
      $year20 := $year+20,
      $maxsermo := if ($series = 1) then ( 3 ) else if ($series = 2) then ( 12 ) else()
     return (
        (: get the date to test against below: $maxyear = the greater of normalized year+21 or 2021; 
            month is defined as $maxsermo above, according to series :) 
        let $maxyear := if ($year20 > 2021 or ($year20 = 2021 and $month > $maxsermo)) then (
                $year20
            ) else (
                2021
            ) 
       
        (: get open year :)
        let $openyear := if ($year30 <= $current-year and $month <= 3) then (
                $current-year 
            ) else if (($year30 < $maxyear)) then (
                $year30
            ) else (
                $maxyear
            )
            
         (: define the return month here. TODO: check. :)        
         let $return-mo :=  if (($year30 >= $maxyear) and ((2021 > $year20) or (2021 = $year20 and $maxsermo >= $month))) then (
               local:get-month-name($maxsermo) 
         ) else (
               local:get-month-name($month)
         )    
         
        (:-------if the open dates are just March or Dec :) 
        let $return-date := string(concat($return-mo,' of ', $openyear))
        (:-------otherwise use the get-month-name() function below... :)
       (: let $return-date := string(concat(local:get-month-name($month), ' of ', $openyear)):)
(:   You're right that it would be better if 2021-03 were processed as 2021 March, but it would probably be a 
million times easier to do this as a find/replace in the resulting xml, right?:)
      return $return-date
     )
(:---------------------------------------------------------------------------------
 : Now process years only YYYY 
 :--------------------------------------------------------------------------------:)
     ) else (
         let $year := number($norm),
         $year31 := $year+31,
         $year21 := $year+21,
         $year11 := $year+11
         return (
             let $maxyear := if ($year21 > 2022) then (
                $year21
             ) else (
                2022
             ) 
        (: get open year :)
        let $openyear := if ($year31 <= $current-year) then (
            $current-year
        ) else if (($year31 < $maxyear)) then (
            $year31
        ) else (
            $maxyear
        )
        return string($openyear)
        )
     )
 };
 
 declare function local:get-month-name($month as xs:double?) as xs:string? {
    if ($month = 1) then (
        "January"
    ) else if ($month = 2) then (
       "February"
    ) else if ($month = 3) then (
        "March"
    ) else if ($month = 4) then (
        "April"
    ) else if ($month = 5) then (
         "May"
    ) else if ($month = 6) then (
         "June"
    ) else if ($month = 7) then (
         "July"
    ) else if ($month = 8) then (
        "August"
    ) else if ($month = 9) then (
       "September"
    ) else if ($month = 10) then (
         "October"
    ) else if ($month = 11) then (
         "November"
    ) else if ($month = 12) then (
        "December"
    ) else()
    
(: to use this switch statement, the XQuery version must be set to 1.1 at the top of this file, and in the scenario click the 'gear' and check enable XQuery 1.1 :)
(:   switch ($month)
    case 1 return "January"
    case 2 return "February"
    case 3 return "March"
    case 4 return "April"
    case 5 return "May"
    case 6 return "June"
    case 7 return "July"
    case 8 return "August"
    case 9 return "September"
    case 10 return "October"
    case 11 return "November"
    case 12 return "December"
    default return "(no month)":)
 };