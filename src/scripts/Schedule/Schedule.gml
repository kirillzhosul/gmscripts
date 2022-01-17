/// @description Schedule system. Allowing you to schedule functions (like every N seconds, or after N seconds), and also call functions after HTTP requests is got response.
// @author (с) 2022 Kirill Zhosul (@kirillzhosul)

#region Private.

gml_pragma("global", "__schedule_gml_init()"); __schedule_gml_init(); // Will call `__schedule_gml_init()` 100%.
function __schedule_gml_init(){
	// @description GML Create event handler.
	
	if (variable_global_exists("__schedule_task_list")) return; // Do not initialise 2+ times.
	
	global.__schedule_task_list = ds_list_create(); // List of the task structures. should be cleaned at the `__schedule_gml_free`.
	
	alarm_set(0, 1); // Setting tick alarm.
}

function __schedule_gml_free(){
	// @description GML Clean up event handler.
	
	// Free memory.
	if (not variable_global_exists("__schedule_task_list")) return;
	ds_map_destroy(global.__schedule_task_list);
}

function __schedule_gml_tick(){
	// @description GML Alarm event handler.
	
	// Iterate over schedule tasks and tick them.
	var tasks_count = ds_list_size(global.__schedule_task_list);
	for (var task_index = 0; task_index < tasks_count; task_index ++){
		var task = ds_list_find_value(global.__schedule_task_list, task_index);
		
		// Locked.
		if (task.__container.awaiting) continue;
		
		if (__schedule_task_tick(task)){
			// If task completed.
			
			// Delete task.
			ds_list_delete(global.__schedule_task_list, task_index);
			delete task;
			
			tasks_count--; // tasks_count = ds_list_size(global.__schedule_task_list);
			continue;
		}
	}

	alarm_set(0, 1); // Setting tick alarm.
}

function __schedule_gml_http(){
	// @description GML HTTP event handler.
	
	var http_request_call_id = async_load[? "id"];
	
	// Iterate over schedule tasks and check if this is for current callback.
	var tasks_count = ds_list_size(global.__schedule_task_list);
	for (var task_index = 0; task_index < tasks_count; task_index ++){
		var task = ds_list_find_value(global.__schedule_task_list, task_index);
		
		if (not variable_struct_exists(task.__container, "http_request_call_id")) continue;
		
		if (task.__container.http_request_call_id == http_request_call_id){
			// If current task is requested this call.
			
			var callback_function = task.__container.callback_function;
			var callback_params = task.__container.callback_params;
		
			callback_function(async_load, callback_params);
			task.__container.awaiting = false;
			
			ds_list_delete(global.__schedule_task_list, task_index);
			return;
		}
	}

}

#endregion

#region Ticking.

function __schedule_task_tick(task){
	// @description Ticks given task.
	// @param {struct[ScheduleTask]} task Task to tick.
	// @returns {bool} Is completed.
	
	if (task.__container.time_left_after - 1 < 1){
		// If time to execute.
		
		if (task.__container.time_every == 0){
			// If no `every` modificator.
			
			var callback_function = task.__container.callback_function;
			var callback_params = task.__container.callback_params;
			var result = callback_function(callback_params);
		
			// Task not returned any (or explicitly returned undefined).
			// Just pass as completed task.
			if (is_undefined(result)) return true;
		
			// If returned true.
			// Retry on next tick.
			if (result) return false;
		
			// If returned not true and not undefined.
			// This is should be false.
			// Which cause resetting to initial state and marking as uncompleted.
			task.__container.time_left_after = task.__container.time_after;
			return false;
		}else{
			if (task.__container.time_left_every - 1 < 1){
				// If time to execute.
				
				var callback_function = task.__container.callback_function;
				var callback_params = task.__container.callback_params;
				var result = callback_function(callback_params);
		
				// Reset timer.
				task.__container.time_left_every = task.__container.time_every;
				
				// Task not returned any (or explicitly returned undefined).
				// Just pass as NOT completed task (to continue every).
				if (is_undefined(result)) return false;
			
				// If returned !undefined.
				// Causes resetting to initial state and marking as uncompleted.
				task.__container.time_left_after = task.__container.time_after;
				return false;
			}
			
			task.__container.time_left_every--;
			return false;
		}
	}

	task.__container.time_left_after--;
	return false;
}

#endregion

#region Schedule task structure.

// Schedule Task private container structure.
// encapsulates data from `ScheduleTask`.
function __ScheduleTaskContainer(callback, params) constructor{
	// Callback information (`callback_function(callback_params)`).
	self.callback_function = callback;
	self.callback_params = params;
	
	// Awaiting locks.
	self.awaiting = false;
	
	// HTTP.
	// self.http_request_call_id = undefined;
	
	// Time information.
	self.time_every = 0;
	self.time_after = 1;
	// Time left information.
	self.time_left_every = self.time_every;
	self.time_left_after = self.time_after;
}

// Schedule Task container structure.
// returned from `schedule()` and all chain operations (as `self`).
function ScheduleTask(callback, params) constructor{
	// Holds all EXECUTION releated information.
	// Should not be modified except schedule core.
	self.__container = new __ScheduleTaskContainer(callback, params);
	
	// Chain operations.
	
	// (task)*.after(delay).*;
	self.after = __schedule_task_chain_after;
	
	// (task)*.every(delay).*;
	self.every = __schedule_task_chain_every; 
	
	// (task)*.http(url, params, method, headers).*;
	self.http = __schedule_task_chain_http; 
};

#region Chain operations.

function __schedule_task_chain_http(url, params, method, headers){
	// @description TODO docs.
	
	// Sending request.
	var http_request_call_id = http_request_simple(url, params, method, headers);
	self.__container.http_request_call_id = http_request_call_id;
	
	// Locking by HTTP.
	self.__container.awaiting = true;
	
	return self; // Returning chain.
}

function __schedule_task_chain_after(delay){
	// @description Delays task for given amount of seconds (resetting previous value).
	// @param {real} delay Delay after, in frames.
	// @returns {struct[ScheduleTask]} Chain contiunation.
	
	// Updating time.
	self.__container.time_after = delay;
	self.__container.time_left_after = self.__container.time_after;
	
	return self; // Returning chain.
}

function __schedule_task_chain_every(delay){
	// @description Makes task to run after given amount of seconds (resetting previous value).
	// @param {real} delay Delay every, in frames.
	// @returns {struct[ScheduleTask]} Chain contiunation.
	
	// Updating time.
	self.__container.time_every = delay;
	self.__container.time_left_every = self.__container.time_every;
	
	return self; // Returning chain.
}

#endregion

#endregion

#region Public.

function schedule(callback, params){
	// @description Schedules given callback as scheduled task and returns it as schedule task structure (allowing you to chain*).
	// @param {function} callback Function that will be called when schedule triggered.
	
	var schedule_task = new ScheduleTask(callback, params); // Create new task.
	ds_list_add(global.__schedule_task_list, schedule_task); // Add task to schedule list.
	
	return schedule_task; // Return task to make chains (Example: schedule(f).*ScheduleTaskFunction()
}

#region Schedule chain aliases (after, every, http).

// Alias for schedule(f).after(t);
function after(delay, callback, params){
	// @description Calls `f` callback, after delay amount of frames.
	return schedule(callback, params).after(delay);
}

// Alias for schedule(f).every(t);
function every(delay, callback, params){
	// @description Calls `f` callback, after delay amount of frames.
	return schedule(callback, params).every(delay);
}

#endregion

#endregion