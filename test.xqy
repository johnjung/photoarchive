define variable $limit {100}

define function prev ($marker) {
if ($marker = 0) then () else
<a>Previous {$limit} results</a>
}

define function next ($new_marker, $count) {
let $remainder := $count - $new_marker
return
if ($remainder > 0) 
then if ($remainder = 1) 
     then <a>Last result</a>
     else <a>Next {if ($remainder > $limit) then $limit else $remainder} results</a>
else ()
}

define function main ($count, $marker) {
let $new_marker := $marker + $limit
return  
if ($new_marker >= $count + $limit) 
then () 
else (
<a>

count: {$count},
{prev($marker)},
new marker: {$new_marker + 1},
remainder: {$count - $new_marker},
{next($new_marker, $count)}</a>,
main($count, $new_marker))
}

main(102, 0)
