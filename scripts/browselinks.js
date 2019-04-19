var BrowseLinks = Class.create({
	initialize: function() {
		var u = window.location.href;

		// List the browses we want links for here.
		// eliminate '2nd browses', where the url contains a pipe.
		if (u.indexOf('browse-') > -1 && u.indexOf('browse-dates') == -1)
			document.observe('dom:loaded', this.buildLinks);
	},
	buildLinks: function() {
		var links = [];

		$$('.narrowcolumn').first().select('li').each(function(l) {
			var letter = l.down('a').innerHTML.substring(0,1).toUpperCase();
			if (links.indexOf(letter) == -1)
				l.writeAttribute('id', 'browse' + letter);
				links.push(letter);
		});

		var p = document.createElement('p');
		$A('ABCDEFGHIJKLMNOPQRSTUVWXYZ').each(function(l) {
			if (links.indexOf(l) > -1) 
				p.appendChild(new Element('a', { href: '#browse' + l }).update(l));
			else	
				p.appendChild(document.createTextNode(l));
			p.appendChild(document.createTextNode(' '));
		});
		$$('.narrowcolumn').first().down('h1').insert({ after: p});

		// HACK BY JEJ. Add a link to the inventory while the rest of
		// this series is being added.
		var u = window.location.href;
		if (u.indexOf('browse-individuals-and-groups') > -1) {
			var html = "All images in this series are not yet available online. See full <a href='http://www.lib.uchicago.edu/e/scrc/collections/archives/photofiles/series1a.html'>inventory</a>.";
			
			p.insert({ after: document.createElement('p').insert(html) });
			$$('div#content ul').first().insert({ after: document.createElement('p').insert(html) });
		}

	}
});

new BrowseLinks();

