<master>
<property name="header_stuff">

	<script type="text/javascript" charset="utf-8">
      function onEndCrop( coords, dimensions ) {
          $( 'x1' ).value = coords.x1;
          $( 'y1' ).value = coords.y1;
		  $( 'width' ).value = dimensions.width;
    	  $( 'height' ).value = dimensions.height;
      }
	</script>
	
	<style type="text/css">
		#CropImageWrap {
			margin: 50px 0 0 50px; 
		}
	</style>

</property>


<div id="CropImageWrap"><img src="@publish_image@" alt="Image" id="Image"></div>


<formtemplate id="crop_image"></formtemplate>


<script type="text/javascript" language="javascript">
    Event.observe( window, 'load', function() {
        new Cropper.Img(
            'Image',
            {
                ratioDim: {
                    x: 430,
                    y: 275
                },
                displayOnInit: true,
                onEndCrop: onEndCrop
            }
        );
    } );
</script>



