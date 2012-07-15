ad_page_contract {
    It shows NFe detailed info

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-06-23

} {
    {nfe_id}
    {return_url ""}
}

set page_title "[_ cnauto-account.NFe_Info]"


db_1row select_nfe {
    SELECT key, prot, date, number, serie, status, motive, nat_op, total, remitter_cnpj, remitter_name, remitter_state_reg, remittee_cnpj, remittee_name, remittee_state_reg FROM cn_nfes WHERE nfe_id = :nfe_id
} -column_array nfe

set email_url ""
set download_url ""