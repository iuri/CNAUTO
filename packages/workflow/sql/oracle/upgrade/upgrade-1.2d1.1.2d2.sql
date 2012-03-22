--
-- Upgrade script
--
-- Adds new fields to workflows
--
-- @author Lars Pind (lars@collaboraid.biz)
--
-- @cvs-id $Id: upgrade-1.2d1.1.2d2.sql,v 1.1 2003/11/13 14:22:03 joela Exp $

alter table workflows add (
  description             clob,
  description_mime_type   varchar2(200) default 'text/plain'
);
