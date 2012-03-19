-- /packages/cnauto-core/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql

SELECT acs_log__debug ('/packages/cnauto-core/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql','');

CREATE SEQUENCE cn_core_file_number_seq cache 1000;
