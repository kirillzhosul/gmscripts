# Game Maker Scripts. 
Collection of some useful scripts in GML (Written by own). Actually, for GM Studio 2.3.

## Documentation.

| Function                                                      | Description                                                                                                                                          |
| --------------------------------------------------------------| ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `http_concat_params(params)`                                  | Concatenate parameters for requests (with `&` GET arguments separator from `ds_map` or `struct`).                                                    |
| `http_request_simple(url, params, method, headers)`           | Request simply with automatic params formatting (from `ds_map` or `struct`), and also `omitting` params / method arguments.                          |
| `string_format_(base, ...)`     or `format(base, ...)`        | Format string with values (replace {} with values). (Also allowed to specify custom format string with `*_ext(base, format, ...) functions`).        |
| `string_split(base, separator)` or `split(base, separator)`   | Split string with separator in to the array of `tokens`.                                                                                             |
