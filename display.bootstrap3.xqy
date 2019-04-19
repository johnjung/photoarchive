module "http://photoarchive.lib.uchicago.edu/display" 

import module namespace lib="http://photoarchive.lib.uchicago.edu/lib" at "lib.xqy"

define variable $limit {100}

define variable $db.xqy {"db.xqy"}

define variable $browsetitles {
<titles>
	<title id="browse1.xml" img="graphics/apf1-02497.jpg" href="apf1-02497.xml">Browse Individuals &amp; Groups</title>
	<title id="browse2.xml" img="graphics/apf2-03004.jpg" href="apf2-03004.xml">Browse Buildings &amp; Grounds</title>
	<title id="browse3.xml" img="graphics/apf3-01998.jpg" href="apf3-01998.xml">Browse Events</title>
	<title id="browse4.xml" img="graphics/apf4-01946.jpg" href="apf4-01946.xml">Browse Student Activities</title>
	<title id="browse6.xml" img="graphics/apf2-08744.jpg" href="apf2-08744.xml">Browse Yerkes Observatory</title>
	<title id="browse7.xml" img="graphics/apf1-06031.jpg" href="apf1-06031.xml">Browse Dates</title>
	<title id="browse8.xml" img="graphics/apf3-01756.jpg" href="apf3-01756.xml">Browse Photographers</title>
	<title id="browse9.xml" img="graphics/apf2-03134.jpg" href="apf2-03134.xml">Browse Subjects</title>
	<title id="browse21.xml" img="graphics/apf2-03004.jpg" href="apf2-03004.xml">Browse Architects</title>
	<title id="browse22.xml" img="graphics/apf2-03004.jpg" href="apf2-03004.xml">Browse Delineators</title>
	<title id="browse23.xml" img="graphics/apf2-03004.jpg" href="apf2-03004.xml">Browse Landscape Designers</title>
	<title id="browse24.xml" img="graphics/apf2-03004.jpg" href="apf2-03004.xml">Browse Sculptors</title>
	<title id="browse25.xml" img="graphics/apf2-03004.jpg" href="apf2-03004.xml">Browse Stained Glass Designers</title>
	<title id="maroon.xml" img="graphics/apf7-04192-002.jpg" href="apf7-04192-002.xml">Browse the Chicago Maroon</title>
	<title id="browse10.xml" img="graphics/apf8-00010.jpg" href="apf8-00010.xml">Browse the Botany Department</title>
	<title id="browse101.xml" img="graphics/apf8-00010.jpg" href="apf8-00010.xml">Browse Scientific Plant Names</title>
	<title id="browse102.xml" img="graphics/apf8-00010.jpg" href="apf8-00010.xml">Browse Common Plant Names</title>
</titles>}

(: FUNCTIONS :)

define function empty-string ($string) {
if ($string = "") then () 
else $string
}

define function make-row ($label, $value) {
if (lib:null($value)) then () 
else <tr><td class="label">{$label}</td><td>{$value}</td></tr>
}

define function format-pi($id) {
fn:concat("http://pi.lib.uchicago.edu/1001/dig/photoarchive/", $id)
}

define function format-browse-results ($list) {
<a href="db.xqy?one={fn:data($browsetitles/*[@id=$list/@id]/@href)}">
<img id="illustration"
src="{fn:data($browsetitles/*[@id=$list/@id]/@img)}"/></a>,
<ul>{format-browse-result(fn:string($list/@id), $list)}</ul>
}

(:
define function format-browse-result-alt ($doc, $results) {
let $letters := fn:distinct-values($results//r/@a)
for $letter in $letters
return for for $val at $v in $results//r[@a = $letter]
       return if ($v = 1)
              then <li id="{$val/@a}"><a href="{$db.xqy}?show={fn:concat($doc, "|", fn:string($val/@id))}">{$val/v/text()} ({$val/c/text()})</a></li>
              else <li><a href="{$db.xqy}?show={fn:concat($doc, "|", fn:string($val/@id))}">{$val/v/text()} ({$val/c/text()})</a></li>
}
:)

define function format-browse-result ($doc, $results) {
for $val in $results//r
return 
<li><a href="{$db.xqy}?show={fn:concat($doc, "|", fn:string($val/@id))}">
{$val/v/text()} ({$val/c/text()})</a></li>
}

(: the first item in the results is a document uri for a results
file. in the case of one result, it's a dummy argument, so we only
process the second argument. :)

define function format-results ($marker, $records) {
let $count := fn:count($records/*)
return 
	if ($count = 1)
	then 
	format-long-result($records[1])
	else 
	for $record in $records/*
	return format-short-result($marker, $record)
}

define function format-short-result ($marker, $record) {
let $id := $record/identifierScanNumber/text()
return 
	<div class="thumb">
		<div class="thumbimage">
			<a href="{$db.xqy}?one={fn:concat($id, '.xml')}">
		  	<img src="{format-pi($id)}/g" alt='{$record/titleName/text()}' />
			</a>
		</div>
		<div class="thumbtext">
			<h3>
				<a href="{$db.xqy}?one={fn:concat($id, '.xml')}">
					{$record/titleName/text()}
				</a>
			</h3>
			<p>
				<a href="{$db.xqy}?one={fn:concat($id, '.xml')}">
					{fn:concat($record/titleTypeName, ' ', $record/titlePhotoSequenceNumber)}
				</a><br/>
				<a href="{$db.xqy}?one={fn:concat($id, '.xml')}">
					{$record/titleSeries}
				</a>
			</p>
		</div>
	</div>
}

define function format-long-result($doc) {
let $id := $doc//identifierScanNumber
return
<div>
<p class='detail'>
		<a href='{format-pi($id)}/r'>
    <img src='{format-pi($id)}/t' alt='{$doc//titleName/text()}' />
		</a>
    <br />
    <a href='{format-pi($id)}/r'>Larger</a>
</p>

	<table id="singleresult">
    {make-row("Title", $doc//titleName/text())}

    {make-row("View", fn:concat($doc//titleTypeName, " ", $doc//titlePhotoSequenceNumber))}

    {make-row("Series", fn:substring-after($doc//titleSeries, "Series "))}

    {make-row("Description", $doc//caption/text()|$doc//description/text())}   
    {make-row("Alternate Name(s)", fn:string-join((
    empty-string($doc//alternateTitle1),
    empty-string($doc//alternateTitle2),
    empty-string($doc//alternateTitle3),
    empty-string($doc//alternateTitle4)), "; " ))}

    {make-row("Subject Terms", fn:string-join((
    empty-string($doc//subject1),
    empty-string($doc//subject2),
    empty-string($doc//subject3),
    empty-string($doc//subject4),
    empty-string($doc//subject5),
    empty-string($doc//subject6)), " | "))}

    {make-row("Scientific Plant Name(s)", fn:string-join((
    empty-string($doc//botanicalScientific1),
    empty-string($doc//botanicalScientific2),
    empty-string($doc//botanicalScientific3),
    empty-string($doc//botanicalScientific4),
    empty-string($doc//botanicalScientific5)), " | "))}

    {make-row("Common Plant Name(s)", fn:string-join((
    empty-string($doc//botanicalCommon1),
    empty-string($doc//botanicalCommon2),
    empty-string($doc//botanicalCommon3),
    empty-string($doc//botanicalCommon4),
    empty-string($doc//botanicalCommon5)), " | "))}
    
    {make-row("Photographer", $doc//creatorPhotographer/text())}   
    
    {make-row("Work of Art Date", $doc//dateArtWorkCreated/text())}   

    {make-row("Photograph Date", $doc//datePhotographCreated/text())}   

    {make-row("Rendering Date", $doc//dateRenderingCreated/text())}   

    {make-row("Plan/Map Date", $doc//datePlanMapCreated/text())}   
    
    {make-row("Physical Format", fn:string-join((
    empty-string($doc//formatOriginalMedium),
    empty-string($doc//formatOriginalExtent)), "; "))}

    {make-row("Architect", fn:string-join((
    empty-string($doc//creatorArchitect1),
    empty-string($doc//creatorArchitect2)), "; " ))}

    {make-row("Delineator", $doc//creatorDelineator/text())}

    {make-row("Artist", $doc//creatorArtist/text())}

    {make-row("Sculptor", $doc//creatorSculptor/text())}

    {make-row("Engraver", $doc//creatorEngraver/text())}   

    {make-row("Manufacturer", $doc//creatorManufacturer/text())}   
    
    {make-row("Stained Glass Designer", $doc//creatorStainedGlassDesigner/text())}

    {make-row("Landscape Designer", fn:string-join((
    empty-string($doc//creatorLandscapeDesigner1),
    empty-string($doc//creatorLandscapeDesigner2)), "; "))}

    {make-row("Completion Date", $doc//dateBuildingGroundsCreated/text())}

    {make-row("Location", fn:string-join((
    empty-string($doc//coverageSpatial1),
    empty-string($doc//coverageSpatial2)), " | "))}

    {make-row("Campus Grid", $doc//coverageSpatial3/text())}

    {make-row("AEP Number", $doc//identifierAEPNumber/text())}

	{make-row("Citation", $doc//bibliographicCitation/text())}
    
    {make-row("Collection", $doc//source/text())}

    {make-row("Repository", $doc//publisher/text())}

	{
		if (fn:starts-with($doc//identifierScanNumber/text(), 'apf7')) 
			then
				<tr><td class="label">Rights and Reproductions</td><td>Copyright held by Chicago Maroon</td></tr>
			else 
				()
	}

    {make-row("Image Identifier", $id/text())}

</table>
        <p>View information about <a href='/rights.html'>rights and permissions</a>.</p>
				<p>View information about <a href='/reproductions.html'>ordering reproductions</a>.</p>
</div>
}

define function title ($results) {
if (fn:count($results/*)=1)
then
<h1>{fn:data($results/*/*[fn:local-name()='titleName'])}</h1>
else if ($results/@show)
     then 
     <h1>{fn:data($results/@show)}</h1>
     else if ($results/@search)
          then 
          <h1>Search results for <em>{fn:data($results/@search)}</em></h1>
          else if ($results/@id)
               then 
               <h1>{fn:data($browsetitles/*[@id=$results/@id])}</h1>
               else 
               <h1>{fn:data($results/*/*[fn:local-name()='titleName'])}</h1>
}

define function breadcrumbs($results) {
if ($results/@show)
then 
<p id='breadcrumbs'>
<a href="/">Home</a> &gt;
<a href="db.xqy?browse={$results/@browse}">{fn:data($browsetitles/*[@id=$results/@browse])}</a> &gt; 
{fn:data($results/@show)}
</p>
else if ($results/@search)
     then 
     <p id='breadcrumbs'>
     <a href="/">Home</a> &gt;
     Search results for <em>{fn:data($results/@search)}</em>
     </p>
     else if ($results/@id)
          then 
          <p id='breadcrumbs'>
          <a href="/">Home</a> &gt; 
          {fn:data($browsetitles/*[@id=$results/@id])}
          </p>
          else 
          <p id='breadcrumbs'>
          <a href="/">Home</a> &gt; 
          {fn:data($results/*/*[fn:local-name()='titleName'])}
          </p>
}

define function pager ($results, $marker) {
if ($results/@query and $results/@count > 1)
then if ($results/@start > 1 or $results/@count > $results/@end)
     then
     <div class="resultspager">
     <p>Results {fn:data($results/@start)} to {fn:data($results/@end)} of {fn:data($results/@count)}.</p>
     {
     if (xs:integer($results/@start) > 1)
     then <p><a href="db.xqy?{$results/@query}&amp;marker={$marker - 1}">Previous results.</a></p>
     else ()
     }
     {
     if (xs:integer($results/@end) < xs:integer($results/@count))
     then <p><a href="db.xqy?{$results/@query}&amp;marker={$marker + 1}">Next results.</a></p>
     else ()
     }
     </div>
     else
		<div class="resultspager">
     <p>{fn:data($results/@count)} results.</p>
		</div>
else ()
}

define function content ($results) {
if ($results/@show)
then 
format-results((), $results)
else if ($results/@search)
     then format-results((), $results)
     else if ($results/@id)
          then format-browse-results($results)
          else format-results((), $results)
}

define function display ($mode, $marker, $results) {
if ($mode = 'xml')
then $results
else
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
<title>{fn:string(title($results))} : Photographic Archive : The University of Chicago</title>

<link rel="stylesheet" href="/css/bootstrap.min.css"/>
<link rel="stylesheet" href="/css/bootstrap-theme.min.css"/>
<link rel="stylesheet" href="/css/photoarchive.css"/>
<script src="/js/jquery-1.11.2.min.js" type="text/javascript"></script>
<script src="/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/js/browselinks.js" type="text/javascript"></script>

</head>
<!--<body id="browsesearchdetail">-->
<body>

<!-- container -->
<div class="container">

  <!-- header -->
  <div class="header row">
    <div class="col-sm-12">
      <a id="logo" href="/">
        <img src="graphics/photofiles-logo.jpg"/>
      </a>
      <div id="nametag">
        <a href="http://www.lib.uchicago.edu/e/">THE UNIVERSITY OF CHICAGO LIBRARY</a></div>
      </div><!-- /nametag -->
    </div><!--/col-sm-12 -->
  </div><!--/row -->

  <!-- navigation -->
  <div class="navigation row">
    {breadcrumbs($results)}
  </div>

  <!-- content -->
  <div class="content row">
    <div class="col-sm-9">
      {
        title($results),
        pager($results, $marker),
        content($results),
        pager($results, $marker)
      }
    </div><!--/col-sm-9-->
  </div><!--/content-->

  <!-- sidebar -->
  <div class="col-sm-3 sidebar">

    <!-- searchbox -->
    <div>
      <h2 style="margin-bottom: .75em;">Search</h2>
      <form method="get" action="db.xqy">
        <input class="form-control" style="margin-bottom: .75em;" type="text" name="keywords"/>
        <input class="btn btn-default" type="submit" value="Search Photographic Archive"/>
      </form>
    </div>

    <!-- browse -->
    { 
      if ($results/@id='browse2.xml' or $results/@id='browse21.xml' or
          $results/@id='browse22.xml' or $results/@id='browse23.xml' or
          $results/@id='browse24.xml' or $results/@id='browse25.xml')
      then
        <div>
          <h2>Browse</h2>
            <ul class="browses">
              <li><a href="browse-individuals-and-groups.html">Individuals &amp; Groups</a></li>
              <li><a href="browse-buildings-and-grounds.html">Buildings &amp; Grounds</a>
                <ul style="margin-top: .34em;">
                  <li><a href="browse-buildings-and-grounds-architects.html">Architects</a></li>
                  <li><a href="browse-buildings-and-grounds-delineators.html">Delineators</a></li>
                  <li><a href="browse-buildings-and-grounds-landscape-designers.html">Landscape Designers</a></li>
                  <li><a href="browse-buildings-and-grounds-sculptors.html">Sculptors</a></li>
                  <li><a href="browse-buildings-and-grounds-stained-glass-designers.html">Stained Glass Designers</a></li></ul></li>
              <li><a href="browse-events.html">Events</a></li>
              <li><a href="browse-student-activities.html">Student Activities</a></li>
              <li class="comingsoon">Sports</li>
              <li><a href="browse-yerkes.html">Yerkes Observatory</a></li>
              <li><a href="browse-maroon.html">Chicago Maroon</a></li>
              <li><a href="browse-botany-department.html">Botany Department</a></li>
              <li><a href="browse-photographers.html">Photographers</a></li>
              <li><a href="browse-subject-terms.html">Subject Terms</a></li>
              <li><a href="browse-dates.html">Dates</a></li>
            </ul>
          </div>
      else 
        if ($results/@id='browse10.xml' or $results/@id='browse101.xml' or $results/@id='browse102.xml')
        then
          <div>
            <h2>Browse</h2>
            <ul class="browses">
            <li><a href="browse-individuals-and-groups.html">Individuals &amp; Groups</a></li>
            <li><a href="browse-buildings-and-grounds.html">Buildings &amp; Grounds</a></li>
            <li><a href="browse-events.html">Events</a></li>
            <li><a href="browse-student-activities.html">Student Activities</a></li>
            <li class="comingsoon">Sports</li>
            <li><a href="browse-yerkes.html">Yerkes Observatory</a></li>
            <li><a href="browse-maroon.html">Chicago Maroon</a></li>
            <li><a href="browse-botany-department.html">Botany Department</a>
<ul style="margin-top: .34em;">
<li><a href="browse-botany-department-scientific-plant-name.html">Scientific Plant Name</a></li>
<li><a href="browse-botany-department-common-plant-name.html">Common Plant Name</a></li></ul></li>
<li><a href="browse-photographers.html">Photographers</a></li>
<li><a href="browse-subject-terms.html">Subject Terms</a></li>
<li><a href="browse-dates.html">Dates</a></li>
</ul>
</div>
else
<div>
<h2>Browse</h2>
<ul class="browses">
<li><a href="browse-individuals-and-groups.html">Individuals &amp;
Groups</a></li>
<li class=""><a href="browse-buildings-and-grounds.html">Buildings &amp; Grounds</a></li>
<li><a href="browse-events.html">Events</a></li>
<li><a href="browse-student-activities.html">Student Activities</a></li>
<li class="comingsoon">Sports</li>
<li><a href="browse-yerkes.html">Yerkes Observatory</a></li>
<li><a href="browse-maroon.html">Chicago Maroon</a></li>
<li><a href="browse-botany-department.html">Botany Department</a></li>
<li><a href="browse-photographers.html">Photographers</a></li>
<li><a href="browse-subject-terms.html">Subject Terms</a></li>
<li><a href="browse-dates.html">Dates</a></li>
</ul>
</div>
}

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

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>

<script type="text/javascript">
try {{
	var pageTracker = _gat._getTracker("UA-7780743-1");
	pageTracker._trackPageview();
}} catch(err) {{}}
</script>

</body>
</html>
}

