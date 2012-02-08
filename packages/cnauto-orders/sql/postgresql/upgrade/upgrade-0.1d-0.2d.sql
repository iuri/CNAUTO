-- /packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql

SELECT acs_log__debug ('/packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql','');

ALTER TABLE cn_orders DROP CONSTRAINT cn_orders_code_un;