

var translideshow1=new translideshow({
wrapperid: "myslideshow", //ID of blank DIV on page to house Slideshow
dimensions: [685, 365], //width/height of gallery in pixels. Should reflect dimensions of largest image
imagearray: [
	     //["/resources/theme-ivc/images/foto1.png"], //["image_path", "optional_link", "optional_target"]
	     //["/resources/theme-ivc/images/foto2.png", "http://en.wikipedia.org/wiki/Cave", "_new"],
	     //["/resources/theme-ivc/images/foto1.png"], //<--no trailing comma after very last image element!
	     ["/resources/theme-ivc/images/foto3.png"] //<--no trailing comma after very last image element!
	     ],
displaymode: {type:'auto', pause:2000, cycles:2, pauseonmouseover:true},
orientation: "h", //Valid values: "h" or "v"
persist: true, //remember last viewed slide and recall within same session?
slideduration: 400 //transition duration (milliseconds)
})


