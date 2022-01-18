/// @description Audio utils.
// @author Kirill Zhosul (@kirillzhosul)
// @version 0.1

#region Playing.

function _audio_play(asset, prority, loop){
	// @description Plays audio.
	// @param {audio} asset Audio asset to play.
	// @param {real} prority Priority of the sound.
	// @param {bool} loop Should we loop sound or not.
	audio_play_sound(asset, prority, loop);
}
	
function _audio_play_music(asset){
	// @description Plays music.
	// @param {audio} asset Audio asset to play.
	_audio_play(asset, 1, true);
}
	
function _audio_play_sound(asset){
	// @description Plays sound.
	// @param {audio} asset Audio asset to play.
	_audio_play(asset, 1, false);
}
	
function _audio_play_notplaying(asset){
	// @description Plays sound only if it is not playing already.
	// @param {audio} asset Audio asset to play.
	if audio_is_playing(asset) return;
	_audio_play_sound(asset);
}

#endregion