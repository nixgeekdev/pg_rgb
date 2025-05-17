\pset null _null_

SET client_min_messages = warning;

CREATE TABLE colors
(
    id    SERIAL PRIMARY KEY,
    name  TEXT,
    color RGB
);

INSERT INTO colors (name, color)
VALUES ('Red', '#FF0000'),
       ('Green', '0, 255, 0'),
       ('Blue', '0,0,255'),
       ('Yellow', to_rgb(255, 255, 0)),
       ('Cyan', '#00FFFF'),
       ('Magenta', '255, 0, 255'),
       ('Fuchsia', '#FF00FF'),
       ('Black', '0,0,0'),
       ('Noir', '0,0,0'::rgb),            -- French
       ('Negro', '#000000':rgb),          -- Spanish
       ('Schwarz', '0, 0, 0'::rgb),       -- German
       ('黒', to_rgb(0, 0, 0)),           -- Japanese kuro
       ('чёрный', to_rgb(0, 0, 0)),       -- Russian chyornyy
       ('White', to_rgb(255, 255, 255)),
       ('Blanco', to_rgb(255, 255, 255)), -- Spanish
       ('Blanc', to_rgb(255, 255, 255)),  -- French
       ('Weiß', to_rgb(255, 255, 255)),   -- German
       ('Bianco', to_rgb(255, 255, 255)), -- Italian
       ('белый', to_rgb(255, 255, 255)),  -- Russian belyy
       ('白', to_rgb(255, 255, 255)),     -- Japanese shiro
       ('أبيض', to_rgb(255, 255, 255)),   -- Arabic abyad
       ('सफेद', to_rgb(255, 255, 255)),    -- Hindi saphed
       ('하얀색', to_rgb(255, 255, 255)),  -- Korean hayan-saek
       ('Gray', '#808080'),
       ('Maroon', '128, 0, 0'),
       ('Olive', '128,128,0'),
       ('Navy', to_rgb(0, 0, 128)),
       ('Teal', '#008080'),
       ('Purple', '128, 0, 128'),
       ('Silver', '192,192,192'),
       ('Orange', to_rgb(255, 165, 0)),
       ('Brown', '#A52A2A'),
       ('Gold', '255, 215, 0'),
       ('Pink', '255,192,203'),
       ('LightBlue', '#ADD8E6'::rgb),
       ('SkyBlue', '135, 206, 235'::rgb),
       ('DeepSkyBlue', '0,191,255'::rgb),
       ('DodgerBlue', to_rgb(30, 144, 255)),
       ('RoyalBlue', '#4169E1'),
       ('SteelBlue', '70, 130, 180'),
       ('SlateBlue', '106,90,205'),
       ('Indigo', to_rgb(75, 0, 130)),
       ('Violet', '#EE82EE'),
       ('Plum', '221, 160, 221'),
       ('Orchid', '218,112,214'),
       ('Lavender', to_rgb(230, 230, 250)),
       ('Thistle', '#D8BFD8'),
       ('Turquoise', '64, 224, 208'),
       ('Aquamarine', '127,255,212'),
       ('MediumTurquoise', to_rgb(72, 209, 204)),
       ('PaleTurquoise', '#AFEEEE'),
       ('DarkTurquoise', '0, 206, 209'),
       ('LightGreen', '144,238,144'),
       ('Lime', to_rgb(0, 255, 0)),
       ('ForestGreen', '#228B22'),
       ('DarkGreen', '0, 100, 0'),
       ('SeaGreen', '46,139,87'),
       ('MediumSeaGreen', to_rgb(60, 179, 113)),
       ('SpringGreen', '#00FF7F'),
       ('LightSeaGreen', '32, 178, 170'),
       ('DarkSlateGray', '47,79,79'),
       ('DarkCyan', to_rgb(0, 139, 139)),
       ('Coral', '#FF7F50'),
       ('Tomato', '255, 99, 71'),
       ('OrangeRed', '255,69,0'),
       ('DarkOrange', to_rgb(255, 140, 0)),
       ('Crimson', '#DC143C'),
       ('FireBrick', '178, 34, 34'),
       ('IndianRed', '205,92,92'),
       ('RosyBrown', to_rgb(188, 143, 143)),
       ('SandyBrown', '#F4A460'),
       ('GoldenRod', '218, 165, 32'),
       ('DarkGoldenRod', '184,134,11'),
       ('Peru', to_rgb(205, 133, 63)),
       ('Chocolate', '#D2691E'),
       ('Tan', '210, 180, 140'),
       ('BurlyWood', '222,184,135'),
       ('Wheat', to_rgb(245, 222, 179)),
       ('Moccasin', '#FFE4B5'),
       ('NavajoWhite', '255, 222, 173'),
       ('PeachPuff', '255,218,185'),
       ('MistyRose', to_rgb(255, 228, 225)),
       ('Salmon', '#FA8072'),
       ('LightSalmon', '255, 160, 122'),
       ('DarkSalmon', '233,150,122'),
       ('LightCoral', to_rgb(240, 128, 128)),
       ('DarkRed', '#8B0000'),
       ('MediumVioletRed', '199, 21, 133'),
       ('PaleVioletRed', '219,112,147'),
       ('DeepPink', to_rgb(255, 20, 147)),
       ('HotPink', '#FF69B4'),
       ('LightPink', '255, 182, 193'),
       ('MediumOrchid', '186,85,211'),
       ('DarkOrchid', to_rgb(153, 50, 204)),
       ('DarkViolet', '#9400D3'),
       ('BlueViolet', '138, 43, 226'),
       ('MediumPurple', '147,112,219'),
       ('RebeccaPurple', to_rgb(102, 51, 153)),
       ('SlateGray', '#708090'),
       ('LightSlateGray', '119, 136, 153'),
       ('MediumSlateBlue', '123,104,238'),
       ('CornflowerBlue', to_rgb(100, 149, 237)),
       ('CadetBlue', '#5F9EA0'),
       ('LightSteelBlue', '176, 196, 222'),
       ('AliceBlue', '240,248,255'),
       ('GhostWhite', to_rgb(248, 248, 255)),
       ('HoneyDew', '#F0FFF0'),
       ('Ivory', '255, 255, 240'),
       ('Linen', '250,240,230'),
       ('OldLace', to_rgb(253, 245, 230)),
       ('PapayaWhip', '#FFEFD5'),
       ('SeaShell', '255, 245, 238'),
       ('Snow', '255,250,250'),
       ('WhiteSmoke', to_rgb(245, 245, 245)),
       ('CyberLime', '#8DFE27'::rgb),
       ('TwilightAsh', '78, 74, 92'::rgb),
       ('NeonFlame', '255,94,58'::rgb),
       ('OceanMist', to_rgb(157, 214, 224)),
       ('DuskyPlum', '#805E87'),
       ('ElectricPumpkin', '255, 107, 0'),
       ('Frostbite', '208,242,255'),
       ('MidnightCactus', to_rgb(34, 68, 34)),
       ('BitterPeach', '#FFB380'),
       ('CraterDust', '156, 148, 137'),
       ('ArcticGlow', '177,255,255'),
       ('SolarRose', to_rgb(252, 108, 156)),
       ('VoidBlue', '#0C1A3F'),
       ('RadioactiveMint', '0, 255, 157'),
       ('LavenderFog', '220,206,255'),
       ('VelvetBronze', to_rgb(153, 102, 51)),
       ('FadedCoral', '#FCAFAF'),
       ('JungleHaze', '51, 136, 107'),
       ('CherryCoal', '48,16,17'),
       ('MangoRush', to_rgb(255, 166, 76));

-- Create a btree index to validate index usability
CREATE INDEX idx_colors_color ON colors USING btree (color);

-- Use EXPLAIN to confirm index is used
EXPLAIN
SELECT *
FROM colors
WHERE color = '#FF0000'::rgb;

-- Test ORDER BY
SELECT *
FROM colors
ORDER BY color;

-- Test relational operators
SELECT A.color, B.color, A.color > B.color as LT
FROM colors A,
     colors B
WHERE A.color > B.color limit 10;

-- Test DISTINCT and GROUP BY support
SELECT DISTINCT color, count(color) as "count"
FROM colors
GROUP BY color
ORDER BY "count" DESC;

-- Accepts hex or decimal
SELECT '#FF00FF'::rgb; -- returns: #FF00FF
SELECT '255,0,255'::rgb; -- returns: #FF00FF

-- Constructor and equality
SELECT make_rgb(255, 0, 255) = '#FF00FF'::rgb; -- true

-- Test casts
SELECT '255,0,255'::text::rgb::text; -- returns #FF00FF
