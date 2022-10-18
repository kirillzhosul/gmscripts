/// @description Utils things to work with HTTP.
// @author (с) 2022 Kirill Zhosul (@kirillzhosul)
// @version 0.1.1


// Features:
// - Concatenate parameters for requests (with `&` GET arguments separator from `ds_map` or `struct`).
// - Request simply with automatic params formatting (from `ds_map` or `struct`), and also `omitting` params / method arguments.


// DS map with all global HTTP headers, removes additional temporary `ds_map` creation,
// which is useless in situation when not using any headers map.
global.HTTP_GLOBAL_HEADERS_MAP = ds_map_create();

#region HTTP Methods (aliases).

// HTTP Methods alises.
// Read more about all types of methods here:
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods

// To make CRUD (Create, Read, Update, Delete) interfaces.
#macro HTTP_METHOD_GET    "GET"    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET
#macro HTTP_METHOD_POST   "POST"   // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST
#macro HTTP_METHOD_PUT    "PUT"    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PUT
#macro HTTP_METHOD_DELETE "DELETE" // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/DELETE
// There is also some rarely used methods,
// which you also may want to use (If server supports them):
#macro HTTP_METHOD_HEAD    "HEAD"    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/HEAD
#macro HTTP_METHOD_CONNECT "CONNECT" // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/CONNECT
#macro HTTP_METHOD_OPTIONS "OPTIONS" // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/OPTIONS
#macro HTTP_METHOD_TRACE   "TRACE"   // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/TRACE
#macro HTTP_METHOD_PATCH   "PATCH"   // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PATCH

// This HTTP method will be used if method argument `omitted`.
#macro HTTP_DEFAULT_METHOD (HTTP_METHOD_GET)

#endregion

#region HTTP concatenate params.

function http_concat_params(params){
	// @description Concatenates params as HTTP params, ready for HTTP requests.
	// @param {struct | ds_map} Params as `struct` or `ds_map`, read *_ext_*() functions for more information.
	// @returns {string | real} Concatenated params, or -1 if invalid params argument.
	
	if (is_struct(params)){
		return http_concat_params_ext_struct(params);
	}
	
	if (ds_exists(params, ds_type_map)){
		return http_concat_params_ext_ds_map(params);
	}
	
	show_debug_message("[http_concat_params] Failed to concatenate params, excepted params to be of the type`struct` or `ds_map`");
	return -1;
}

// Notice: *_ext_*() may used via just `http_concat_params()`!

function http_concat_params_ext_struct(params){
	// @description Concatenates given structure params as HTTP params, ready for HTTP requests.
	// @param {struct} params Structure, where params will be converted to HTTP params (except methods).
	// @returns {string} Concatenated HTTP params string.
	
	var concatenated_params = "";
	
	var params_names = variable_struct_get_names(params);
	var params_count = array_length(params_names);
	for (var param_index = 0; param_index < params_count; param_index++){
		var param_name = array_get(params_names, param_index);
		var param_value = variable_struct_get(params, param_name);
		
		if (is_method(param_value)) continue;
		
		concatenated_params += param_name + "=" +  string(param_value); 
		concatenated_params += (param_index == (params_count - 1) ? "" : "&"); // Adds `&` if this is not last element.
	}
	
	return concatenated_params;
}

function http_concat_params_ext_ds_map(params){
	// @description Concatenates given ds_map as HTTP params, ready for HTTP requests.
	// @param {struct} params Structure, where params will be converted to HTTP params (except methods).
	// @returns {string} Concatenated HTTP params string.
	
	var concatenated_params = "";
	
	var params_names = ds_map_keys_to_array(params);
	var params_count = array_length(params_names);
	for (var param_index = 0; param_index < params_count; param_index++){
		var param_name = array_get(params_names, param_index);
		var param_value = ds_map_find_value(params, param_name);
		
		concatenated_params += param_name + "=" +  string(param_value); 
		concatenated_params += (param_index == (params_count - 1) ? "" : "&"); // Adds `&` if this is not last element.
	}
	
	return concatenated_params;
}

#endregion

#region HTTP Requests.

function http_request_simple(url, params=undefined, method=undefined, headers=undefined){
	// @description Wrapper for `http_request`, automatic params formatting, supported `omitting` of the arguments (params / method / headers).
	// @param {string} url URL address as string where to send request.
	// @param {struct | ds_map | undefined (omitt)} params Structure, where params will be converted to HTTP params, may be omitted.
	// @param {string | undefined (omitt)} method HTTP method as string, or one from aliases HTTP_METHOD_*, may be omitted.
	// @param {ds_map | undefined (omitt)} headers HTTP headers as ds_map, may be omitted.
	// @returns {real} HTTP request index, or -1 if failure (invalid argument, actually).
	
	if (is_undefined(url) or not is_string(url)){
		show_debug_message("[http_request_simple] Failed to send request, `url` argument is required and should be of the type `string`!");
		return -1;
	}
	
	http_headers ??= global.HTTP_GLOBAL_HEADERS_MAP;
	if (not ds_exists(http_headers, ds_type_map)){
		show_debug_message("[http_request_simple] Failed to send request, `headers` argument is not of the type `ds_map`!");
		return -1;
	}
	
	http_method ??= HTTP_DEFAULT_METHOD;
	if (not is_string(http_method)){
		show_debug_message("[http_request_simple] Failed to send request, `method` argument is not of the type `string`!");
		return -1;
	}

	// Notice: null-coalescing is new GML feature.
	// May be replaced with `params = (is_undefined(params) ? "" : params)`
	params ??= {}; // TODO - Error. 
	params = is_struct(params) or ds_exists(params, ds_type_map) ? http_concat_params(params) : params;
	if (not is_string(params)){
		// Notice: GML `http_request` also allows buffers, which will be recognized as error.
		// this is not VERY bad as this is `SIMPLE` function.
		show_debug_message("[http_request_simple] Failed to send request, `method` argument is not of the type `string` (If you trying to pass buffer here, please read notice inside function! (Not allowed))!");
		return -1;
	}
	
	// Requesting resource.
	return http_request(url, http_method, global.HTTP_GLOBAL_HEADERS_MAP, params)
}

#endregion
