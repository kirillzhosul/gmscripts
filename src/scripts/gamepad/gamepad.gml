/// @description: System for working with gamepads in system.
/// @author: Kirill Zhosul.

#region Functions.

function gamepad_get_working_index(){
	// @description Function for getting latest gamepad working index.
	// @returns {real} Gamepad index.
	return gamepad_get(0);
}

function gamepad_get(index){
	// @description Gets gamepad index from array index to work with 2+ gamepads.
	// @param {real} index Array index for getting gamepad index.
	
	if (index > global.gamepad_count - 1) return 0;
	return global.gamepad_indeces[index];
}

function gamepad_get_working_is_xbox(){
	// @description Returns is working gamepad XBOX or not.
	// @returns {real} Gamepad index.
	return gamepad_is_xbox(0);
}

function gamepad_is_xbox(index){
	// @description Returns is given xbox index is XBOX or not.
	// @param {real} index Array index for getting is XBOX or not.
	if (index > global.gamepad_count - 1) return false;
	return global.gamepad_indeces[index] < 4;
}

function gamepad_system_event(){
	// @description System gamepad event.

	var type = async_load[? "event_type"];
	
	switch(type){
		case "gamepad discovered":
			// Shifting all elements in array so that there is a place for a new gamepad.
			for(var _index = global.gamepad_count - 1;_index >= 0;_index --){
				global.gamepad_indeces[_index + 1] = global.gamepad_indeces[_index];
			}
			
			// Setting zero index (Working gamepad) to new connected gamepad.
			global.gamepad_indeces[0] = async_load[? "pad_index"];
			global.gamepad_count ++;
		break;
		case "gamepad lost":
			for (var _index = 0;_index < global.gamepad_count;_index++){
				// Iterating over all gamepads in array.
			
				if global.gamepad_indeces[_index] == async_load[? "pad_index"]{
					// If current gamepad queals to disconnected gamepad.
					
					// Sorting array to have index for deletion at the end.
					if _index != gamepad_get_count() - 1{
						// If it is not arleady last index.
						
						// Shifting index.
						for(var _index_sort = _index + 1;_index_sort < gamepad_get_count();_index_sort ++){
							global.gamepad_indeces[_index_sort - 1] = global.gamepad_indeces[_index_sort];
						}
					}
					
					// Deleting disconnected gamepad index.
					array_pop(global.gamepad_indeces);
					global.gamepad_count --;
					break;
				}
			}
		break;
	}
}

function gamepad_system_search(){
	// @description Search connected gamepads in system.
	
	// Clearing list.
	global.gamepad_indeces = [];
	global.gamepad_count = 0;

	for(var _index = 0;_index <= gamepad_get_device_count(); _index++){
		// Iterating over all gamepads in the system.
		
		// Adding gamepad to list if it is connected.
		if gamepad_is_connected(_index){
			array_push(global.gamepad_indeces, _index);
			global.gamepad_count ++;
		}
	}
}

function gamepad_get_count(){
	// @description Returns gamepad count.
	// @returns {real} Gamepad count.
	return global.gamepad_count;
}
	
#endregion

#region Entry point of the system.

// Array of connected gamepads indeces (Where 0 is last connected gamepad).
global.gamepad_indeces = undefined;

// Count of the connected gamepads founded.
global.gamepad_count = 0;

// Starting searching of the gamepads in the system as soon as game starts.
gamepad_system_search();

#endregion