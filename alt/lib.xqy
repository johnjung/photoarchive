module "http://marklogic.lib.uchicago.edu:8003/lib" 

define function null ($i) {
if ($i = "" or fn:empty($i)) then fn:true() else fn:false()
}

(: usage: split-string(normalize-space(" a c"), " ", ()) :)
(: this: split-string(normalize-space(" a c"), " ", "") returns "" at
   the beginning of the sequence :)

define function split-string($string, $token, $acc) {
if ($string = "") 
then $acc
else if (fn:not(fn:contains($string, $token))) 
        then ($acc, $string) 
        else let $a := fn:substring-after($string, $token),
                 $b := fn:substring-before($string, $token)
             return split-string($a, $token, ($acc, $b))
}

(: this function is for testing :)

define function output-error ($i) {
xdmp:set-response-content-type("text/xml"),
<record>{$i}</record>
}

