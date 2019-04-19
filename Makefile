all : static 
	@wget -nv -O browse-individuals-and-groups.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse1.xml
	@wget -nv -O browse-buildings-and-grounds.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse2.xml
	@wget -nv -O browse-buildings-and-grounds-architects.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse21.xml
	@wget -nv -O browse-buildings-and-grounds-delineators.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse22.xml
	@wget -nv -O browse-buildings-and-grounds-landscape-designers.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse23.xml
	@wget -nv -O browse-buildings-and-grounds-sculptors.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse24.xml
	@wget -nv -O browse-buildings-and-grounds-stained-glass-designers.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse25.xml
	@wget -nv -O browse-events.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse3.xml
	@wget -nv -O browse-student-activities.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse4.xml
	@wget -nv -O browse-sports.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse5.xml
	@wget -nv -O browse-yerkes.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse6.xml
	@wget -nv -O browse-photographers.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse8.xml
	@wget -nv -O browse-subject-terms.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse9.xml
	@wget -nv -O browse-dates.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse7.xml
	@wget -nv -O browse-maroon.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=maroon.xml
	@wget -nv -O browse-botany-department.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse10.xml
	@wget -nv -O browse-botany-department-scientific-plant-name.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse101.xml
	@wget -nv -O browse-botany-department-common-plant-name.html \
	http://photoarchive.lib.uchicago.edu/db.xqy?browse=browse102.xml

static : aboutthecollection.html bannerimages.html reproductions.html rights.html technicalinfo.html

%.html : %.xml
	@wget -nv -O /dev/null http://photoarchive.lib.uchicago.edu/load.xqy?url=$<
	@wget -nv -O $@ http://photoarchive.lib.uchicago.edu/make.xqy?url=$<

