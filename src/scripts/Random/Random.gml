/// @description Random utils.
// @author Kirill Zhosul (@kirillzhosul)
// @version 0.1

// Features.
// - Get chance.

#region Chance.

function chance(procent){
	// @description Returns that chance is success or failure.
	// @param {real} _procent Chance of success.
	// @returns {bool} Result of the chance.
	return procent > random(100);
}

#endregion