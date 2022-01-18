/// @description Simple `Publisher - Subscriber` pattern implementation.
// @author (c) 2022 Kirill Zhosul (@kirillzhosul)
// @version 0.1

// Features:
// - Create `Publishers` as on_* notifiers.
// - Notify `Subscribers` that subscribed you about callback.
// - Subscribe.

// TODO: Unsubscribe.

// Notice:
// This code mplements simple `Publisher - Subscriber` pattern.
// Should be used to create relations for instances, when parent instance will publish changes,
// and children will just catch it by own function, not editing source.
	
#region Publisher.

function Publisher() constructor{
	// Struct, that will control PARENT instance,
	// that works with NOTIFYING childerns (via notify method).
	
	// Array with all functions, that will be called. 
	self.__subscribers = [];
	
	self.subscribe = function(subscriber){
		// @description Subscribes on publisher.
		// @param {function} subscriber_function Function to subscribe.
		
		// May be unsafe!...
		if (typeof(subscriber) != "struct"){
			// Wrap in struct.
			subscriber = new Subscriber(subscriber);
		}
		
		array_push(self.__subscribers, subscriber);
	}
	
	self.notify = function(args){
		// @description Triggers (invoking) all subscribers.
		// @param {any} args Data Transfer Object*.
		
		for(var subscriber_index = 0; subscriber_index < array_length(self.__subscribers); subscriber_index++){
			var subscriber = self.__subscribers[subscriber_index];
			subscriber.on_notify(args);
		}
	}
}

#endregion

#region Subscriber.

function Subscriber(callback) constructor{
	// Wrapper for the callback. May be not used, as Publisher will wrap in this by own.
	
	// Function which be called when notify.
	self.__callback_function = callback;
	
	self.on_notify = function(args){
		// @descripton Trigger for notfiy() of the publisher.
		self.__callback_function(args);
	}
}

#endregion