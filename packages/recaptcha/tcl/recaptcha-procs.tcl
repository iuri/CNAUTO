ad_library {

    reCAPTCHA Library

    @creation-date 2010-04-20
    @author Alessandro Landim <alessandro.landim@gmail.com>

}

namespace eval recaptcha {}

ad_proc -public recaptcha::create {
	{-form}
} {
	Create a recaptha in the form
} {
	#parameter
	set fp [open "[acs_root_dir]/packages/recaptcha/public_key.txt" r]
	set your_public_key [read $fp]
	close $fp


	ad_form -extend -name $form -form {
		{recaptcha_service:text,optional
			{label "#recaptcha.Title#"}
			{html {id recaptcha_service}}
			{after_html {
			  <script>
				var RecaptchaOptions = {
					   theme : 'clean',
					   lang : 'pt'
				};
			  </script>
			  <script type="text/javascript"
			    src="http://api.recaptcha.net/challenge?k=$your_public_key">
			  </script>
			  <script type="text/javascript">
				document.getElementById('recaptcha_service').style.display = 'none';
			  </script>
			  <noscript>
			    <iframe src="http://api.recaptcha.net/noscript?k=$your_public_key"
				        height="300" width="500" frameborder="0"></iframe><br>
		          </noscript>
			}}
		}
		{recaptcha_response_field:text(hidden),optional}
		{recaptcha_challenge_field:text(hidden),optional}
	} -validate {
        {recaptcha_service
                {[recaptcha::check -challenge_field $recaptcha_challenge_field -response_field $recaptcha_response_field]}
                "Error"
        }
	}
}


ad_proc -public recaptcha::check {
        {-challenge_field}
        {-response_field}
} {
     #parameter
     set fp [open "[acs_root_dir]/packages/recaptcha/private_key.txt" r]
     set your_private_key [read $fp]
     close $fp

     set RECAPTCHA_VERIFY_SERVER api-verify.recaptcha.net
     set server [ad_conn peeraddr]
     
     set resp [util_httppost http://$RECAPTCHA_VERIFY_SERVER/verify "privatekey=$your_private_key&remoteip=$server&challenge=$challenge_field&response=$response_field" 120]
     
     return [lindex $resp 0]

}
