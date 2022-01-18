/// @description Initialisation.
// @author (с) 2022 Kirill Zhosul (@kirillzhosul)

scheduled_inc_val = 0;

schedule(function (){
	scheduled_inc_val ++;
}, self).every(room_speed * 1.5);
// OR.
// every(room_speed * 1.5, function (){
//	scheduled_inc_val ++;
//}, self)

schedule(function (r){
	show_message_async("This message will be shown when http response from google will come");
}, self).await_http(http_get("http://google.com"));


// Notice: do not raise fatal/error logs, by default,
// They will come with `show_error`.
//logging_log(LOGGING_LOG_LEVEL.FATAL, "This is fatal log!");
//logging_log(LOGGING_LOG_LEVEL.ERROR, "This is error log!");
logging_log(LOGGING_LOG_LEVEL.WARN, "This is warn log!");
logging_log(LOGGING_LOG_LEVEL.INFO, "This is info log!");
logging_log(LOGGING_LOG_LEVEL.DEBUG, "This is debug log!");
logging_log(LOGGING_LOG_LEVEL.TRACE, "This is trace log!");