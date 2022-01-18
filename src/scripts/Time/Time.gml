/// @description Time utils.
// @author Kirill Zhosul (@kirillzhosul)
// @version 0.1

// Features:
// - Convert seconds to frames.

// May be useful when working with game logic,
// Or even with `schedule()` utils.

#region Seconds.

function seconds(seconds){
	// @alias time_seconds2frames(seconds)
	return time_seconds2frames(seconds)
}
function time_seconds2frames(seconds){
	// @description Converts seconds to frames.
	// @param {real} seconds Seconds which will be converted to frames.
	// @returns {real} Frames that was converted from seconds.
	return round(room_speed * seconds);
}

#endregion