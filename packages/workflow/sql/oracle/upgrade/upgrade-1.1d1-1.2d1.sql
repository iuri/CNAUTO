--
-- Upgrade script
--
-- Adds useful views
--
-- @author Lars Pind (lars@collaboraid.biz)
--
-- @cvs-id $Id: upgrade-1.1d1-1.2d1.sql,v 1.1 2003/10/30 11:14:47 joela Exp $

alter table workflow_actions add (
  description             clob,
  description_mime_type   varchar2(200) default 'text/plain'
);
