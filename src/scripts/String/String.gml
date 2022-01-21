/// @description Utils things to work with strings.
// @author (с) 2022 Kirill Zhosul (@kirillzhosul)
// @version 0.1


// Features:
// - Format string with values (replace {} with values). (Also allowed to specify custom format string).
// - Split string with separator in to the array of `tokens`.


#region String formatting.

// `string_format_`  will format (replace) that string with passed arguments.
#macro STRING_FORMAT_FORMAT "{}"

// If true, this is will NOT write undefined to format.
// If false, may cause `undefined` appears when you not passed all arguments to format, and there is place to format.
#macro STRING_FORMAT_DISSALOW_UNDEFINED true

// Do not change.
// Used to create string formatting aliases.
#macro STRING_FORMAT_ARGUMENTS_ALIAS_EXT argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13, argument14, argument15
#macro STRING_FORMAT_ARGUMENTS_ALIAS argument0, STRING_FORMAT_ARGUMENTS_ALIAS_EXT

function format(base){ // Alias, for `string_format_(base, ...)`.
	// @alias string_format_(base)
	return string_format_(STRING_FORMAT_ARGUMENTS_ALIAS);
}
function string_format_(base){ // Alias, for `string_format_ext(base, format, ...)`
	// @alias string_format_ext(base, format)
	return string_format_ext(base, STRING_FORMAT_FORMAT, STRING_FORMAT_ARGUMENTS_ALIAS_EXT);
}

function format_ext(base, format){ // Alias, for `string_format_ext(base, format...)`.
	// @alias string_format_ext(base, format)
	return string_format_ext(STRING_FORMAT_ARGUMENTS_ALIAS);
}
function string_format_ext(base, format){
	// @description Replaces `format` in `base` with arguments
	// @param {string} base String in which we replacing.
	// @param {string} format String which we replacing.
	// @params {strings} Replace strings.
	// @returns {string} Formatted string.
	for (var argument_index = 2; argument_index < argument_count; argument_index++) {
		var element = argument[argument_index];
		if (STRING_FORMAT_DISSALOW_UNDEFINED){
			if (is_undefined(element)) continue;
		}
		
	    base = string_replace(base, format, string(element));
	}
	
	return base;
}

#endregion

#region String splitting.

// `string_split` will use that separator to split if `omitted`.
#macro STRING_SPLIT_SEPARATOR " "

function split(base, separator=STRING_SPLIT_SEPARATOR){ // Alias, for `string_split(base, separator)`.
	// @alias string_split(base, separator)
	return string_split(base, separator);
}
function string_split(base, separator=STRING_SPLIT_SEPARATOR){
	// @description Splits string in to the array (of `tokens`) with given separator.
	// @param {string} base String  which we splitting.
	// @param {string | undefined (May be omitted)} separator String with which we splitting, may be omitted.
	// @returns {array[strings]} Array of splitted strings (tokens).
	
	separator ??= STRING_SPLIT_SEPARATOR;
	
	var tokens = [];
	var buffer = "";
	
	for (var char_index = 1; char_index < string_length(base); char_index++){
		var char = string_char_at(base, char_index);
		
		if (char == separator){
			array_push(tokens, buffer);
			buffer = "";
			continue;
		}
		
		buffer += char;
	}
	
	return tokens;
}

#endregion