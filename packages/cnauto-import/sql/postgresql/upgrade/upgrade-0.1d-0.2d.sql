-- /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql

SELECT acs_log__debug ('/packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql', '');


ALTER TABLE cn_import_workflows ADD COLUMN sort_order integer;
