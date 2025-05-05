\pset null _null_

SET client_min_messages = warning;

CREATE TABLE colors (
    id SERIAL PRIMARY KEY,
    name TEXT,
    color RGB
);

-- TODO there is something wrong with the values in the DB below;
INSERT INTO colors (name, color) VALUES
    ('Fuchsia', '#FF00FF'),          -- #FF00FF
    ('Sky', '135,206,235'),          -- #87CEEB
    ('Black', '#000000'),            -- #000000
    ('Orange', to_rgb(255,165,0)),   -- #FFA500
    ('Red', to_rgb(255,0,0)),        -- #FF0000
    ('Green', to_rgb(0,255,0)),      -- #00FF00
    ('Blue', to_rgb(0,0,255)),       -- #0000FF
    ('Yellow', to_rgb(255,255,0)),   -- #FFFF00
    ('Cyan', to_rgb(0,255,255)),     -- #00FFFF
    ('Magenta', to_rgb(255,0,255)),  -- #FF00FF
    ('Black', to_rgb(0,0,0)),        -- #000000
    ('White', to_rgb(255,255,255)),  -- #FFFFFF
    ('Gray', to_rgb(128,128,128));   -- #808080

-- Create a btree index to validate index usability
CREATE INDEX idx_colors_color ON colors USING btree (color);

-- Use EXPLAIN to confirm index is used
EXPLAIN SELECT * FROM colors WHERE color = '#FF0000'::rgb;

-- Test ORDER BY
SELECT * FROM colors ORDER BY color;

-- Test relational operators
SELECT A.color, B.color, A.color > B.color as LT
FROM colors A, colors B
WHERE A.color > B.color
    limit 10;

-- Test DISTINCT and GROUP BY support
SELECT DISTINCT color, count(color) as "count"
FROM colors GROUP BY color ORDER BY "count" DESC;

-- Accepts hex or decimal
SELECT '#FF00FF'::rgb;        -- returns: #FF00FF
SELECT '255,0,255'::rgb;      -- returns: #FF00FF

-- Constructor and equality
SELECT make_rgb(255, 0, 255) = '#FF00FF'::rgb;  -- true

-- Test casts
SELECT '255,0,255'::text::rgb::text;  -- returns #FF00FF
