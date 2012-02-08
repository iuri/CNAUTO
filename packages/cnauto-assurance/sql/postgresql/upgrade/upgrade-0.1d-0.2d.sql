-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.1d-0.2d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.1d-0.2d.sql', '');


ALTER TABLE cn_assurances ADD COLUMN person_id integer;
ALTER TABLE cn_assurances ADD CONSTRAINT  cn_assurances_person_id_fk FOREIGN KEY (person_id) REFERENCES cn_persons (person_id) ON DELETE CASCADE;


ALTER TABLE cn_assurances DROP CONSTRAINT  cn_assurances_vehicle_id_fk;

ALTER TABLE cn_assurances ADD CONSTRAINT  cn_assurances_vehicle_id_fk FOREIGN KEY (vehicle_id) REFERENCES cn_vehicles (vehicle_id) ON DELETE CASCADE;


ALTER TABLE cn_assurances ADD COLUMN part_id integer;

ALTER TABLE cn_assurances ADD CONSTRAINT cn_assurances_part_id_fk FOREIGN KEY (part_id)REFERENCES cn_parts (part_id) ON DELETE CASCADE;



