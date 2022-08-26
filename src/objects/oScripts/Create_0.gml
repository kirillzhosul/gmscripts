/// @description Creating objects.
// @author (с) 2022 Kirill Zhosul (@kirillzhosul)

// Layer on which we creating instances.
#macro SCRIPTS_OBJECTS_LAYER "Instances"

#region Validate objects.

var layer_id = layer_get_id(SCRIPTS_OBJECTS_LAYER);
var create_function = layer_exists(layer_id) ? instance_create_layer : instance_create_depth;
var is_created = not instance_exists(oLogging) or not instance_exists(oGamepad);

// Create instances.
if (not instance_exists(oLogging)) create_function(0, 0, layer_id, oLogging);
if (not instance_exists(oGamepad)) create_function(0, 0, layer_id, oGamepad);

// Logging.
if (create_function == instance_create_depth and is_created){
	logging_log(LOGGING_LOG_LEVEL.WARN, "`oScripts` creating scripts objects via `instance_create_depth`, please update `SCRIPTS_OBJECTS_LAYER` or create layer!");
}else{
	if (is_created){
		logging_log(LOGGING_LOG_LEVEL.INFO, "`oScripts` successfully created required objects on layer!");
	}else{
		logging_log(LOGGING_LOG_LEVEL.INFO, "`oScripts` skipped creating objects on layer, as they all already created!");
	}
}

instance_destroy(); // End work.

#endregion