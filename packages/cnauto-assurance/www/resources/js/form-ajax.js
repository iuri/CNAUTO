function AjaxFunction(cat_id) {
    var httpxml;
    try {
	// Firefox, Opera 8.0+, Safari
	httpxml=new XMLHttpRequest();
    }
    catch (e) {
	// Internet Explorer
	try {
	    httpxml=new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch (e) {
	    try {
		httpxml=new ActiveXObject("Microsoft.XMLHTTP");
	    }
	    catch (e) {
		alert("Your browser does not support AJAX!");
		return false;
	    }
	}
    }
    
    function stateck() {
	if(httpxml.readyState==4) {
	    var myarray=eval(httpxml.responseText);
	    // Before adding new we must remove previously loaded elements
	    for(j=document.testform.subcat.options.length-1;j>=0;j--) {
		document.testform.subcat.remove(j);
	    }
	    
	    for (i=0;i<myarray.length;i++) {
		var optn = document.createElement("OPTION");
		optn.text = myarray[i];
		optn.value = myarray[i];
		document.testform.subcat.options.add(optn);
		
	    } 
	}
    }
    
    var url="get-vehicle-info";
    url=url+"?vehicle_id="+vehicle_id;
    url=url+"&sid="+Math.random();
    httpxml.onreadystatechange=stateck;
    httpxml.open("GET",url,true);
    httpxml.send(null);
}

