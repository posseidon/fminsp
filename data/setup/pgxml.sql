/* $PostgreSQL: pgsql/contrib/xml2/pgxml.sql.in,v 1.11.4.1 2010/03/01 18:08:07 tgl Exp $ */

-- Adjust this setting to control where the objects get created.
SET search_path = public;

--SQL for XML parser

CREATE OR REPLACE FUNCTION xml_is_well_formed(text) RETURNS bool
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;

-- deprecated old name for xml_is_well_formed
CREATE OR REPLACE FUNCTION xml_valid(text) RETURNS bool
AS '$libdir/pgxml', 'xml_is_well_formed'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION xml_encode_special_chars(text) RETURNS text
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION xpath_string(text,text) RETURNS text
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION xpath_nodeset(text,text,text,text) RETURNS text
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION xpath_number(text,text) RETURNS float4
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION xpath_bool(text,text) RETURNS boolean
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;

-- List function

CREATE OR REPLACE FUNCTION xpath_list(text,text,text) RETURNS text
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION xpath_list(text,text) RETURNS text
AS 'SELECT xpath_list($1,$2,'','')'
LANGUAGE SQL STRICT IMMUTABLE;

-- Wrapper functions for nodeset where no tags needed

CREATE OR REPLACE FUNCTION xpath_nodeset(text,text)
RETURNS text
AS 'SELECT xpath_nodeset($1,$2,'''','''')'
LANGUAGE SQL STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION xpath_nodeset(text,text,text)
RETURNS text
AS 'SELECT xpath_nodeset($1,$2,'''',$3)'
LANGUAGE SQL STRICT IMMUTABLE;

-- Table function

CREATE OR REPLACE FUNCTION xpath_table(text,text,text,text,text)
RETURNS setof record
AS '$libdir/pgxml'
LANGUAGE C STRICT STABLE;

-- XSLT functions

CREATE OR REPLACE FUNCTION xslt_process(text,text,text)
RETURNS text
AS '$libdir/pgxml'
LANGUAGE C STRICT VOLATILE;

-- the function checks for the correct argument count
CREATE OR REPLACE FUNCTION xslt_process(text,text)
RETURNS text
AS '$libdir/pgxml'
LANGUAGE C STRICT IMMUTABLE;
