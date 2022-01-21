/// @description Draw.
// @author (с) 2022 Kirill Zhosul (@kirillzhosul)

draw_text(0, 0 , "http_concat_params({test: 1, key: undefined})");
draw_text(20, 20, http_concat_params({test: 1, key: undefined}));

draw_text(0, 60 , "string_split(\"hello world gml\")");