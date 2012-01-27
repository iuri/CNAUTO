-- /packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql','');

ALTER TABLE cn_workflow_steps ADD COLUMN order_id integer;

ALTER TABLE cn_workflow_steps ADD CONSTRAINT cn_workflow_steps_order_id_fk FOREIGN KEY (order_id) REFERENCES cn_orders (order_id);

