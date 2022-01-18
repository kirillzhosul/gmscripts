/// @description Utils things to work with logging.
// @author Kirill Zhosul (@kirillzhosul)
// @version 0.1


// Features:
// - Log with different logging levels (error/debug/trace).
// - Log saved to file.


// Other.
#macro LOGGING_RAISE_ERRORS true // If true, allows to levels after LOGGING_CURRENT_RAISE_ERRORS_LEVEL.

// Paths.
#macro LOGGING_LOGS_DIRECTORY_PATH (working_directory + "/logs/") // Path to directory with logs.
#macro LOGGING_LOGS_FILE_EXTENSION ".log.txt" // Log files extension. 

// Logfile will be written to file before exit if there is more than N lines.
#macro LOGGING_LOGS_FILE_LINES_BUFFER 256

#region Levels (log, echo).

// Logging log level. (Log severity marker).
enum LOGGING_LOG_LEVEL{
	// Used as marker to not show any messages.
	OFF = 0, 
	// Error.
	FATAL = 10,
	ERROR = 20,
	WARN  = 30,
	// Information.
	INFO  = 40,
	DEBUG = 50,
	TRACE = 60,
	// Used as marker to show ALL messages.
	ALL = 100
}
// CURRENT logging log level, see `LOGGING_LEVEL` to get hierarchy of levels.
#macro LOGGING_CURRENT_LOG_LEVEL (LOGGING_LOG_LEVEL.ALL)
// Levels after that, will automatically raise error, but only if LOGGING_RAISE_ERRORS enabled.
#macro LOGGING_CURRENT_RAISE_ERRORS_LEVEL (LOGGING_LOG_LEVEL.ERROR)

// Logging echo level. (Where to echo log).
enum LOGGING_ECHO_LEVEL{
	LOGFILE = 2,
	CONSOLE = 8,
}
// Current echo level. Sum of levels in `LOGGING_ECHO_LEVEL` (Flags).
#macro LOGGING_CURRENT_ECHO_LEVEL (LOGGING_ECHO_LEVEL.LOGFILE + LOGGING_ECHO_LEVEL.CONSOLE)

#endregion

#region Public.

#region Log message.

function logging_log(level, message){
	// @description Logs message with given level.
	// @param {real[LOGGING_LOG_LEVEL]} level Logging level.
	// @param {string} message Message to log.
	if (level > LOGGING_CURRENT_LOG_LEVEL) return;

	message = logging_format_message(level, message);
	
	if (LOGGING_RAISE_ERRORS){
		if (level <= LOGGING_CURRENT_RAISE_ERRORS_LEVEL){
			show_error(message, true);
		}
	}
	
	if (LOGGING_CURRENT_ECHO_LEVEL & LOGGING_ECHO_LEVEL.LOGFILE){
		__logging_handle_file_write(message);
	}
	
	if (LOGGING_CURRENT_ECHO_LEVEL & LOGGING_ECHO_LEVEL.CONSOLE){
		show_debug_message(message);
	}
}

#endregion

#region Utils.

function logging_format_message(level, message){
	// @description Formats message due to it level.
	// @param {real[LOGGING_LOG_LEVEL]} level Level of the log.
	// @param {string} message Message that we logging.
	
	switch(level){
		case LOGGING_LOG_LEVEL.FATAL: return "[:FATAL:] " + message;
		case LOGGING_LOG_LEVEL.ERROR: return "[:ERROR:] " + message;
		case LOGGING_LOG_LEVEL.WARN: return "[:WARN:] " + message;
		case LOGGING_LOG_LEVEL.INFO: return "[:INFO:] " + message;
		case LOGGING_LOG_LEVEL.DEBUG: return "[:DEBUG:] " + message;
		case LOGGING_LOG_LEVEL.TRACE: return "[:TRACE:] " + message;
		
		case LOGGING_LOG_LEVEL.ALL: return "[:ALL:] " + message;
		case LOGGING_LOG_LEVEL.OFF: return "[:OFF:] " + message;
		
		default: return message;
	}
}

#endregion

#endregion

#region Private.

#region Entry / Exit points.

gml_pragma("global", "__logging_init()"); // To call over all places, before they called.
function __logging_init(){
	// @description Initialises logging.
	if (variable_global_exists("__logging_is_initialized")) return;
	
	global.__logging_is_initialized = true;
	
	global.__logging_log_file		= file_text_open_write(__logging_generate_log_filename());
	global.__logging_log_file_lines = 0;
}

function __logging_free(){
	// @description Freeing logging used memory.
	if (not variable_global_exists("__logging_is_initialized")) return;
	file_text_close(global.__logging_log_file);
}

#endregion

#endregion

#region Private.

function __logging_handle_file_write(message){
	var log_file = variable_global_get("__logging_log_file");
	if (is_undefined(log_file)){
		show_error(":ERROR: Logging can`t echo to the file, as log file is not initialised, there is should be `logging_init()` called before any logging!", false);
		return;
	}
		
	file_text_write_string(log_file, message);
	file_text_writeln(log_file);
		
	global.__logging_log_file_lines ++;
	if (global.__logging_log_file_lines >= LOGGING_LOGS_FILE_LINES_BUFFER){
		file_text_close(global.__logging_log_file)
		global.__logging_log_file		= file_text_open_write(__logging_generate_log_filename());
		global.__logging_log_file_lines = 0;
	}
}
function __logging_generate_log_filename(){
	// @description Generates log filename due to current time.
	// @returns {string} Log filename.
	
	var log_datetime = date_current_datetime();
	
	var log_year = date_get_year(log_datetime);
	var log_month = date_get_month(log_datetime);
	var log_day = date_get_day(log_datetime);
	var log_hour = date_get_hour(log_datetime);
	var log_minute = date_get_minute(log_datetime);
	var log_second = date_get_second(log_datetime);
	
	var log_filename = string_format_("{}.{}.{} {}.{}.{}", log_year, log_month, log_day, log_hour, log_minute, log_second);
	var log_filename = LOGGING_LOGS_DIRECTORY_PATH + log_filename + LOGGING_LOGS_FILE_EXTENSION;
	
	return log_filename;
}

#endregion