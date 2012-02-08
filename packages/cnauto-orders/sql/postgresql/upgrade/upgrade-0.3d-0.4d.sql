-- /packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql

SELECT acs_log__debug ('/packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql','');


ALTER TABLE cn_orders ADD COLUMN parent_id integer;
ALTER TABLE cn_orders ADD CONSTRAINT cn_orders_parent_id_fk FOREIGN KEY (parent_id) REFERENCES cn_orders (order_id);
