ad_page_contract {
  Cancel email to the list

  @author Alessandro Landim

} {
	newsletter_id:integer
}



ad_form -name cancel -export {newsletter_id} -form {
	{email:text} 
} -on_submit {
	newsletters::email::not_valid -email $email -newsletter_id $newsletter_id
} -after_submit {
	ad_returnredirect -message "Seu e-mail foi retirada desses boletim." .
}


