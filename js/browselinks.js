$(document).ready(function() {		
    var u = window.location.href;

    // Make sure it's a browse.
    if (u.indexOf('browse-') == -1) {
        return;
    }

	var links = [];

    var html = "<p id='letterlinks' style='padding-bottom: 0;'>";
    if (u.indexOf('browse-dates') > -1) {
	    $('.browseresults li').each(function() {
		    var letter = $(this).text().substring(0,3);
		    if (links.indexOf(letter) == -1) {
                $(this).attr('id', 'browse' + letter);
			    links.push(letter);
            }
        });

        $.each(['185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200'], function(i, l) {
            if (links.indexOf(l) > -1) {
                html = html + "<a href='#browse" + l + "'>" + l + "0s</a>";
	        } else {
                html = html + l + "0s";
            }
            html = html + ' ';
        });
    } else {
	    $('.browseresults li').each(function() {
		    var letter = $(this).text().substring(0,1);
		    if (links.indexOf(letter) == -1) {
                $(this).attr('id', 'browse' + letter);
			    links.push(letter);
            }
        });

        $.each(['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'], function(i, l) {
            if (links.indexOf(l) > -1) {
                html = html + "<a href='#browse" + l + "'>" + l + "</a>";
	        } else {
                html = html + l;
            }
            html = html + ' ';
	    });
    }

    $('.browseresults').prepend(html);

    // HACK BY JEJ. Add a link to the inventory while the rest of
    // this series is being added.
    var u = window.location.href;
    if (u.indexOf('browse-individuals-and-groups') > -1) {
	    var html = "<p style='padding-bottom: 0;'>All images in this series are not yet available online. See full <a href='http://www.lib.uchicago.edu/e/scrc/collections/archives/photofiles/series1a.html'>inventory</a>.</p>";
			
        $('#letterlinks').after(html);
	}
});

