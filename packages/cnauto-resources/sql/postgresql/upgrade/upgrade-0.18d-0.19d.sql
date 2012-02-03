-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.18d-0.19d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.18d-0.19d.sql','');

ALTER TABLE cn_vehicles DROP CONSTRAINT cn_vehicles_vin_un;
