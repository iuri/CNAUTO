/****
 *
 *  A library to manipulate layers
 *
 *  Browser and OS Compatability:
 *	
 *	Internet Explorer 6+ 			(Windows XP, Max OSX)
 *	Netscape/Mozilla/FireFox 1.0	     	(Windows, Macs)
 *	Safari		     			(Mac OSX)
 *	Opera (?)
 *      Konqueror (?)
 *
 *  @cvs-id $Id: layer-procs.js,v 1.2 2007/01/04 09:04:10 avnik Exp $
 *	
 **/

/* Show or hide the layer 

	@param action show or hide, if empty string will just toggle the layer
*/
function showHideWidget(layerId,action) {
	var edit_section = document.getElementById(layerId).style;
	if (action == null || action == '') {
		if (edit_section.display == '') {
			edit_section.display='none';
		} else {
			edit_section.display='';
		}
	} else if (action == 'show') {
		edit_section.display='';
	} else if (action == 'hide') {
		edit_section.display='none';
	}
}
