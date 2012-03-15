--
-- Upgrade script
--
-- Adds useful views
--
-- @author Lars Pind (lars@collaboraid.biz)
--
-- @cvs-id $Id: upgrade-1.1d1-1.2d1.sql,v 1.1 2003/10/30 11:14:47 joela Exp $

alter table workflow_actions
	add description text;

alter table workflow_actions
	add description_mime_type varchar(200);

alter table workflow_actions 
  alter column description_mime_type set default 'text/plain';
