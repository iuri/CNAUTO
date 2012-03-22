--
-- The CN SpreadSheet Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2011-09-18
--

------------------------------------
-- CN SpreadSheet Data
------------------------------------

DROP FUNCTION cn_spreadsheet_data__del (integer);

DROP FUNCTION cn_spreadsheet_data__new (integer, varchar, varchar);

DROP TABLE cn_spreadsheet_data;



------------------------------------
-- CN SpreadSheet Elements
------------------------------------

DROP FUNCTION cn_spreadsheet_elements__new (integer, varchar, varchar);

DROP SEQUENCE cn_spreadsheet_element_id_seq;

DROP TABLE cn_spreadsheet_elements;



------------------------------------
-- CN SpreadSheet Items
------------------------------------


DROP FUNCTION cn_spreadsheet_items__del (integer);

DROP FUNCTION cn_spreadsheet_items__new (integer, integer, varchar, varchar, integer, varchar, integer, timestamp with time zone, integer, varchar, integer);


DROP TABLE cn_spreadsheet_items;

SELECT acs_object_type__drop_type ('cn_spreadsheet_item', 't');


------------------------------------
-- CN SpreadSheet Fields
------------------------------------
DROP FUNCTION cn_spreadsheet_fields__del (integer);

DROP FUNCTION cn_spreadsheet_fields__edit (integer, varchar, integer, boolean);

DROP FUNCTION cn_spreadsheet_fields__new (integer, integer, varchar, integer, timestamp with time zone, integer, varchar, integer);

DROP TABLE cn_spreadsheet_fields;

SELECT acs_object_type__drop_type ('cn_spreadsheet_field', 't');



------------------------------------
-- CN SpreadSheets
------------------------------------

DROP FUNCTION cn_spreadsheet__edit (integer, varchar, varchar);

DROP FUNCTION cn_spreadsheet__del (integer);

DROP FUNCTION cn_spreadsheet__new (integer, varchar, varchar, integer, timestamp with time zone, integer, varchar, integer);

DROP TABLE cn_spreadsheets;

SELECT acs_object_type__drop_type ('cn_spreadsheet', 't');