SET client_min_messages TO warning;
SET log_min_messages    TO warning;

CREATE TYPE rgb;

CREATE OR REPLACE FUNCTION to_rgb(int, int, int) RETURNS rgb AS 'MODULE_PATHNAME', 'to_rgb' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION hash_rgb(rgb) RETURNS integer AS 'MODULE_PATHNAME', 'hash_rgb' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION rgb_in(cstring) RETURNS rgb AS 'MODULE_PATHNAME', 'rgb_in' LANGUAGE C IMMUTABLE STRICT;
CREATE OR REPLACE FUNCTION rgb_out(rgb) RETURNS cstring AS 'MODULE_PATHNAME', 'rgb_out' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION rgb_cmp(rgb, rgb) RETURNS int4 AS 'MODULE_PATHNAME', 'rgb_cmp' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION rgb_lt(rgb, rgb) RETURNS boolean AS 'MODULE_PATHNAME', 'rgb_lt' LANGUAGE C IMMUTABLE STRICT;
CREATE OR REPLACE FUNCTION rgb_le(rgb, rgb) RETURNS boolean AS 'MODULE_PATHNAME', 'rgb_le' LANGUAGE C IMMUTABLE STRICT;
CREATE OR REPLACE FUNCTION rgb_eq(rgb, rgb) RETURNS boolean AS 'MODULE_PATHNAME', 'rgb_eq' LANGUAGE C IMMUTABLE STRICT;
CREATE OR REPLACE FUNCTION rgb_gt(rgb, rgb) RETURNS boolean AS 'MODULE_PATHNAME', 'rgb_gt' LANGUAGE C IMMUTABLE STRICT;
CREATE OR REPLACE FUNCTION rgb_ge(rgb, rgb) RETURNS boolean AS 'MODULE_PATHNAME', 'rgb_ge' LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE rgb (
    INTERNALLENGTH = 12,
    INPUT = rgb_in,
    OUTPUT = rgb_out,
    STORAGE = plain,
    ALIGNMENT = int4,
    PASSEDBYVALUE = false
);

CREATE FUNCTION text_to_rgb(text) RETURNS rgb
AS $$
SELECT rgb_in($1::cstring);
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE FUNCTION rgb_to_text(rgb) RETURNS text
AS $$
SELECT rgb_out($1)::text;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE CAST (text as rgb) WITH FUNCTION text_to_rgb(text) AS ASSIGNMENT;
CREATE CAST (rgb AS text) WITH FUNCTION rgb_to_text(rgb) AS ASSIGNMENT;

CREATE OPERATOR = (
    LEFTARG = rgb,
    RIGHTARG = rgb,
    PROCEDURE = rgb_eq,
    COMMUTATOR = =,
    NEGATOR = !=,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);

CREATE OPERATOR < (
    LEFTARG = rgb,
    RIGHTARG = rgb,
    PROCEDURE = rgb_lt,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);

CREATE OPERATOR > (
    LEFTARG = rgb,
    RIGHTARG = rgb,
    PROCEDURE = rgb_gt,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);

CREATE OPERATOR <= (
    LEFTARG = rgb,
    RIGHTARG = rgb,
    PROCEDURE = rgb_le,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);

CREATE OPERATOR >= (
    LEFTARG = rgb,
    RIGHTARG = rgb,
    PROCEDURE = rgb_ge,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);

CREATE OPERATOR CLASS rgb_hash_ops
DEFAULT FOR TYPE rgb USING hash AS
    OPERATOR 1 = ,
    FUNCTION 1 hash_rgb(rgb);

CREATE OPERATOR CLASS rgb_btree_ops
  DEFAULT FOR TYPE rgb USING btree AS
    OPERATOR 1 < ,
    OPERATOR 2 <=,
    OPERATOR 3 = ,
    OPERATOR 4 >=,
    OPERATOR 5 > ,
    FUNCTION 1 rgb_cmp(rgb, rgb);
