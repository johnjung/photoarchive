import module namespace lib="http://photoarchive.lib.uchicago.edu/lib" at "lib.xqy"

import module namespace display="http://photoarchive.lib.uchicago.edu/display" at
"display.xqy"

define variable $collection {"photoarchive"}

(: the code had been getting rid of double quotes at this point. 
   I let them through to be able to do phrase searching. :)

define function get-user-input ($input) {
normalize-space(xdmp:get-request-field($input))
}

define function keyword-query ($keywords) {
for $i in lib:split-string-or-phrase($keywords, " ", ())
return cts:word-query($i, "unstemmed")
}

(:
  helper function. xquery can't order numerically,
  so this function helps fake it. 
:)
define function pad-with-zeros ($input) {
let $pad := '0000000000'
return 
if ($input)
then
fn:concat(fn:substring($pad, 0, fn:string-length($pad) - fn:string-length($input)),
          $input)
else
$pad
}

define function keyword-search ($keywords, $marker) {
let $results := 
    for $d in cts:search(collection("photoarchive")/*, 
                         cts:and-query((keyword-query($keywords))))
    order by $d/titleName, $d/titleTypeName, pad-with-zeros($d/titlePhotoSequenceNumber)
    return $d 
let $count := fn:count($results)
let $start := ($marker - 1) * 100 + 1
let $end   := fn:min(($count, $marker * 100))

return
<records
 search = "{$keywords}"
 count  = "{$count}"
 start  = "{$start}"
 end    = "{$end}"
 query  = "keywords={$keywords}">
{
for $r at $c in $results
where $c >= $start and $c <= $end
return $r
}
</records>
}       

(:
	<list id="browse.xml">
		<r id="1">
			<v>title</v>
			<c>count</c>
		</r>
		...
	</list>

  group on substring($r/v, 0, 1).
  I want the first r of each group to have a group attribute-
  the first letter of v. 

:)

(:
  How do I get the browse to group on first letter????
let $records := fn:doc($b)/list/r,
    $groups  := fn:distinct-values(for $r in $records return fn:substring($r/v, 1, 1))
return
<list id="{$b}">
{
for $group at $g in $groups,
    $record at $r in $records
where fn:substring($record/v, 1, 1) = $group
return
if ($g = 1)
then
<r id="{$r}" a="{$g}">{$record/v, $record/c}</r>
else
<r id="{$r}">{$record/v, $record/c}</r>
}
</list>
:)

define function browsesort ($s) {
	replace(string($s), '^[^/]*(\d{4})(-\d{2})?(-\d{2})?.*$', '$1$2$3')
}

define function browse ($b) {
let $records := fn:doc($b)/list/r,
    $letters := fn:distinct-values(for $r in $records 
                                   return fn:substring($r/v, 1, 1))
return
<list id="{$b}">
{
for $letter at $l in $letters
return for $record at $r in $records
       where fn:substring($record/v, 1, 1) = $letter
       order by if ($b = 'browse7.xml')
                then browsesort($record/v)
                else $record/v
       return <r id="{$r}" a="browse{$letter}">{$record/v, $record/c}</r>
}
</list>
}

define function show ($s, $marker) {
if ($s) 
then let $b       := fn:substring-before($s, "|"),
  	     $i       := xs:integer(fn:substring-after($s, "|")),
         $r       := fn:doc($b)/list/r[position() = $i],
         $count   := fn:count($r/u),
         $start   := ($marker - 1) * 100 + 1,
         $end     := fn:min(($count, $marker * 100)),
         $records := for $u in $r/u
                     order by fn:doc($u)//titleName, fn:doc($u)//titleTypeName, pad-with-zeros(fn:doc($u)//titlePhotoSequenceNumber)
                     return fn:doc($u)
     return 
         <records
          browse = "{$b}" 
          show   = "{$r/v}"
          count  = "{$count}"
          start  = "{$start}"
          end    = "{$end}"
          query  = "show={$s}">
         {
         for $record at $c in $records
         where $c >= $start and $c <= $end
         return $record
         }
         </records>
else ()
}

define function results ($i) {
<records>
{ for $i in lib:split-string($i, "|", ()) return fn:doc($i) }
</records>
}

(: MAIN :)

let 
    $i_browse := get-user-input("browse"),
    $i_keywords := get-user-input("keywords"),
    $i_marker := get-user-input("marker"),
    $i_mode := get-user-input("mode"),
    $i_one := get-user-input("one"),
    $i_show := get-user-input("show"),

    $s_browse := browse($i_browse),
    $s_marker := if (lib:null($i_marker)) then 1 else fn:number($i_marker),
    $s_keywords := if (lib:null($i_keywords)) then () else keyword-search($i_keywords, $s_marker),
    $s_show := show($i_show, $s_marker)

return
if ($i_one) 
then display:display($i_mode, (), fn:doc($i_one))
else if ($i_keywords)
     then display:display($i_mode, $s_marker, $s_keywords)
     else if ($i_browse)
          then display:display($i_mode, (), $s_browse) 
          else if ($i_show)
               then display:display($i_mode, $s_marker, $s_show) 
               else ()

(: lib:output-error(fn:count((1, fn:doc($one)))) :)

