$(function(){
    var btnUpload=$('#upload');
    var status=$('#status');
    new AjaxUpload(btnUpload, {
	action: 'file-add',
	name: 'uploadfile',
	onSubmit: function(file, ext){
	    if (! (ext && /^(jpg|png|jpeg|gif)$/.test(ext))){ 
                // extension is not allowed 
		status.text('Only JPG, PNG or GIF files are allowed');
		return false;
	    }
	    status.text('Uploading...');
	},
	onComplete: function(file, response){
	    //On completion clear the status
	    status.text('');
	    //Add uploaded file to list
	    if(response==="success"){
		$('<li></li>').appendTo('#files').html('<img src="./uploads/'+file+'" alt="" /><br />'+file).addClass('success');
	    } else{
		$('<li></li>').appendTo('#files').text(file).addClass('error');
	    }
	}
    });
    
});

