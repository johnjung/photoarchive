define function split-string($string, $token, $acc) {
if ($string = "")
then $acc
else if (fn:not(fn:contains($string, $token)))
        then ($acc, $string)
        else let $a := fn:substring-after($string, $token),
                 $b := fn:substring-before($string, $token)
             return split-string($a, $token, ($acc, $b))
}

define function keyword-search ($keywords) {
cts:search(//record, cts:and-query((cts:collection-query(("photoarchive")),
(for $i in split-string($keywords, " ", ()) return cts:word-query($i)))))}

define function p ($results) {
for $i in $results order by $i//titleName, $i//titleTypeName,  $i//titlePhotoSequenceNumber
return $i
}

p (keyword-search("harper"))


