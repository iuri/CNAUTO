-- /packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.4d-0.5d.sql


SELECT acs_log__debug ('/packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.4d-0.5d.sql','');

ALTER TABLE cn_spreadsheet_fields ADD COLUMN sort_order integer;

