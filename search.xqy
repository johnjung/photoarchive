import module namespace lib="http://marklogic.lib.uchicago.edu:8003/lib" at "lib.xqy"

define function keyword-query ($keywords) {
for $i in lib:split-string($keywords, " ", ())
return cts:word-query($i)
}

define function keyword-search ($keywords, $elements) {
cts:search(//record, 
    cts:and-query((cts:collection-query(("photoarchive")),
        cts:or-query((
           for $i in $elements
           return cts:element-query(xs:QName($i), 
                                    cts:and-query((keyword-query($keywords))))
                    ))
)))
}       

let $a := xdmp:get-request-field("search")
let $elements := (
"titleSeries", 
"titleName",
"titleTypeName",
"identifierScanNumber",
"titlePhotoSequenceNumber",
"alternateTitle1",
"alternateTitle2",
"alternateTitle3",
"alternateTitle4",
"dateBuildingGroundsCreated",
"creatorArchitect1",
"creatorArchitect2",
"creatorDelineator",
"creatorArtist",
"creatorLandscapeDesigner1",
"creatorLandscapeDesigner2",
"creatorSculptor",
"creatorStainedGlassDesigner",
"datePhotographCreated",
"creatorPhotographer",
"creatorEngraver",
"caption",
"description",
"subject1",
"subject2",
"subject3",
"subject4",
"subject5",
"subject6",
"coverageSpatial1",
"coverageSpatial2",
"coverageSpatial3",
"formatOriginalMedium",
"formatOriginalExtent",
"source",
"relationIsPartOf",
"publisher"
)
return keyword-search($a, $elements)

