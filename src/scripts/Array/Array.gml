/// @description Array utils.
// @author Kirill Zhosul (@kirillzhosul)
// @version 0.1

// Features:
// - Choice from array.
// - Shuffle array.
// - Swap array.

#region Choice.

function choice(array){
	// @alias array_choice(array).
	return array_choice(array);
}
function array_choice(array){
	// @desrciption Returns one random element from the array.
	// @param {array} array Array to choice from.

	var random_index = irandom_range(0, array_length(array) - 1);
	return array[@ random_index];
}

#endregion

#region Shuffle.

function array_shuffle(array){ 
	// @description Shuffles array and NOT returns it (if you want get return as array, use array_shuffleD).
	// @param {array} array Array to shuffle.
	// Getting array size.
	
	var array_length_ = array_length(array);
	for (var i = 0; i < array_length_; i++){
	    var new_index = irandom_range(i, array_length_ - 1);
	    if (new_index == i) continue;
		array_swap(array, i, new_index);
	}
}

#endregion

#region Swap.

function array_swap(array, from, to){
	// @description Swaps array indeces.
	// @param {array} array Array to swap.
	// @param {real} from First index.
	// @param {real} to Second index.
	var buffer = array[@ to];
	array[@ to] = array[@ from];
	array[@ from] = buffer;
}

#endregion