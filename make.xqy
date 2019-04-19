declare namespace functx = "http://www.functx.com"

define variable $url { xdmp:get-request-field('url') }

define variable $sideeffect {
	xdmp:document-load(fn:concat('http://photoarchive.lib.uchicago.edu/', $url),
	<options xmlns="xdmp:document-load">
		<uri>{$url}</uri>
	</options>) }

define variable $html { functx:change-element-ns-deep(
	fn:doc($url)/*[1], "http://www.w3.org/1999/xhtml") }

define function functx:change-element-ns-deep
($element as element(), $newns as xs:string) as element() {
	let $newName := QName($newns, local-name($element))
	return ( element { $newName }
		{ $element/@*,
		for $child in $element/node()
		return if ($child instance of element())
		       then functx:change-element-ns-deep($child, $newns)
		       else $child
		}
	)
}

xdmp:set-response-content-type("text/html; charset=utf-8"),
"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN'
   'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>",
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<meta name="keywords" content="pictures, photographs, photos, pics,
black and white, archives, history, document, old, Chicago, university,
college, campus"/>
<meta name="description" content="The Photographic Archive
contains more than 60,000 images documenting the history of the
University of Chicago."/> 
<title>{ fn:string($html/head/title) }</title>
<link href="css/reset.css" rel="stylesheet" type="text/css"/>
<link href="css/layout.css" rel="stylesheet" type="text/css"/>
<link href="css/type.css" rel="stylesheet" type="text/css"/>
<link href="css/main.css" rel="stylesheet" type="text/css"/>
<link href="css/intro.css" rel="stylesheet" type="text/css"/>
<script src="/js/jquery-1.11.2.min.js"></script>
<script src="/js/ga.js"></script>
<!--[if lt IE 6]>
<link href="css/ie5.css" rel="stylesheet" type="text/css"/>
<![endif]-->
</head>
<body>

<!-- MAIN -->
<div id="main">

<!-- HEADER -->
<div id="header">
<a id="logo" href="/">
<img alt="The University of Chicago Photographic Archive" src="graphics/photofiles-logo.jpg"/>
</a>
<div id="nametag">
<a href="http://www.lib.uchicago.edu/e/">THE UNIVERSITY OF CHICAGO LIBRARY</a></div>
</div><!-- /HEADER -->

<!-- NAVIGATION -->
<div class="navigation">
<p id="breadcrumbs"><a href="/">Home</a> &gt; {fn:string($html//h1[1])}</p>
</div>

<!-- CONTAINER -->
<div id="container">

<!-- CONTENT -->
<div id="content">{ $html/body/* }</div>
<!--/CONTENT-->

<!-- SIDEBAR -->
<div id="sidebar">

<!-- SEARCHBOX -->
<div>
<h2 style="margin-bottom: .75em;">Search</h2>
<form method="get" action="db.xqy">
<input class="textinput" style="margin-bottom: .75em;" type="text" name="keywords"/>
<input type="submit" value="Search Photographic Archive"/>
</form>
</div>

<!-- BROWSE -->
<div>
<h2>Browse</h2>
<ul class="browses">
<li><a href="browse-individuals-and-groups.html">Individuals &amp; Groups</a></li>
<li><a href="browse-buildings-and-grounds.html">Buildings &amp; Grounds</a></li>
<li><a href="browse-events.html">Events</a></li>
<li><a href="browse-student-activities.html">Student Activities</a></li>
<li><a href="browse-sports.html">Sports</a></li>
<li><a href="browse-yerkes.html">Yerkes Observatory</a></li>
<li><a href="browse-maroon.html">Chicago Maroon</a></li>
<li><a href="browse-botany-department.html">Botany Department</a></li>
<li><a href="browse-photographers.html">Photographers</a></li>
<li><a href="browse-subject-terms.html">Subject Terms</a></li>
<li><a href="browse-dates.html">Dates</a></li>
</ul>
</div>

<div style="background: none;">
<h2>About this Project</h2>
<ul>
<li><a href="aboutthecollection.html">About the Collection</a></li>
<li><a href="reproductions.html">Ordering Reproductions</a></li>
<li><a href="rights.html">Rights and Permissions</a></li>
<li><a href="technicalinfo.html">Technical Information</a></li>
<li><a href="bannerimages.html">Banner Images</a></li>
<li><a href="http://www.lib.uchicago.edu/e/spcl/">Special Collections
Research Center</a></li>
</ul>
</div>

</div>
<!--/SIDEBAR-->

</div>
<!--/CONTAINER-->

<!-- FOOTER -->
<div id="footer">&nbsp;</div>

</div><!--/MAIN-->
</body>
</html>
