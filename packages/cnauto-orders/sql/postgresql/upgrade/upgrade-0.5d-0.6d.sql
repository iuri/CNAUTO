-- /packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql

SELECT acs_log__debug ('/packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql','');


ALTER TABLE cn_orders ADD COLUMN enabled_p boolean default 't';
 