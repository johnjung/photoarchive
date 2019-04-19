if (!JEJ) 
	var JEJ = {};

JEJ.doubleDelegate = function(f1, f2) {
	return function() {
		if (f1) 
			f1();
		if (f2) 
			f2();
	}
}

/*
 * I want the child ul's to be invisible.
 * I want the child a's to call a function to toggle the visibility
 * of their children. 
 */

JEJ.setupExpandables = function() {
	var expandables = getElementsByClassName('expandable');
	// HIDE EXPANDABLE UL'S
	for (var x=0; x < expandables.length; x++) {
		var sublists = expandables[x].getElementsByTagName('ul');
		for (var l=0; l < sublists.length; l++) {
			sublists[l].style.display = 'none';
		}
	}
	// SETUP ONCLICKS ON A'S.
	for (var x=0; x < expandables.length; x++) {
		var sublists = expandables[x].getElementsByTagName('a');
		sublists[0].onclick = JEJ.toggleExpandable;
	}
}
window.onload = JEJ.doubleDelegate(window.onload, JEJ.setupExpandables);

/*
 * function to toggle an expandable UL
 * I'd also like this to display a small plus or minus sign.
 * can I get this to only expand a single level of heirarchy?
 */

JEJ.toggleExpandable = function() {
	// this.parentNode is the li that
	// is class expandable.
	// change to expandable expanded
	// when it's open. 
	var expandable = this.parentNode;
	expandableul = null;
	for (var e=0; e < expandable.childNodes.length; e++) {
		if (expandable.childNodes[e].nodeName == 'UL') {
			expandableul = expandable.childNodes[e];
			if (expandableul.style.display == 'none') {
				expandable.className = 'expandable expanded'; 
				expandableul.style.display = '';
			} else {
				expandable.className = 'expandable collapsed';
				expandableul.style.display = 'none';
			}
			break;
		}
	}
	return false;
}
