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
}, self).http("http://google.com");
// OR.
// http("google.com", function (){
//	show_message_async("This message will be shown when http response from google will come");
//}, self)