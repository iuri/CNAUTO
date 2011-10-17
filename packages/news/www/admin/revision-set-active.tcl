# /packages/news/www/admin/revision-set-active.tcl

ad_page_contract {
    
    This page changes the active revision of a news item and returns to item

    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id: revision-set-active.tcl,v 1.1.1.1 2006/05/13 17:20:50 tekne Exp $
    
} {

    item_id:integer,notnull
    new_rev_id:integer,notnull
    
}


db_exec_plsql update_forum {
    begin
       news.revision_set_active (:new_rev_id);
    end;
}
    
ad_returnredirect "item?item_id=$item_id"






