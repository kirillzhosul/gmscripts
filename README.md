# Game Maker Scripts. 
Collection of some useful scripts in GML (Written by own). Actually, for GM Studio 2.3.

## Docementation.
- HTTP:
- - Concatenate parameters for requests (with `&` GET arguments separator from `ds_map` or `struct`).
- - - `http_concat_params(params)`
- - Request simply with automatic params formatting (from `ds_map` or `struct`), and also `omitting` params / method arguments.
- - - `http_request_simple(url, params, method, headers)`
- String:
- - Format string with values (replace {} with values). (Also allowed to specify custom format string with `*_ext(base, format, ...) functions`).
- - - `string_format_(base, ...)` or via alias `format(base, ...)`
- - Split string with separator in to the array of `tokens`.
- - - - `string_split(base, separator)` or via alias `split(base, separator)`
