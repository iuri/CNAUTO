ad_page_contract {
} {
    {file_id ""}
}
    

ns_log Notice "It Works! $file_id"
set filename [db_string select_filename {
    SELECT name FROM cr_items WHERE item_id = :file_id
}]

acs_mail_lite::send \
    -send_immediately \
    -from_addr "iuri.sampaio@cnauto.com.br" \
    -to_addr "iuri.sampaio@gmail.com" \
    -subject "CN Auto S.A. - $filename" \
    -body "This is an automatic email requested by the user to receive the NFe as an XML file.\n Please see the file attached.\n\n Best wishes,\n Iuri Sampaio \n Analista de Sistemas\n CN Auto S.A." \
    -file_ids $file_id

ad_script_abort