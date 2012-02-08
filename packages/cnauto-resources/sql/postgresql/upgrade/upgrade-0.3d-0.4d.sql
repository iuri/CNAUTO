-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql','');

ALTER TABLE cn_persons ALTER COLUMN code TYPE varchar(100);
ALTER TABLE cn_persons ALTER COLUMN type TYPE varchar(100);