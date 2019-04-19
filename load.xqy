declare namespace functx = "http://www.functx.com"

define variable $url { xdmp:get-request-field('url') }

xdmp:document-load(fn:concat('http://photoarchive.lib.uchicago.edu/', $url),
<options xmlns="xdmp:document-load">
	<uri>{$url}</uri>
</options>)
