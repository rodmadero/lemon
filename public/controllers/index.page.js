var eventBus = {
    carousel: riot.observable(),
	explorer: riot.observable()
};
riot.mixin('event-bus',{events: eventBus});
