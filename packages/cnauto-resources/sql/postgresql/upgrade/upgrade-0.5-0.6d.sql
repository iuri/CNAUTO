-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql','');

ALTER TABLE cn_categories ADD COLUMN pretty_name varchar(50);
