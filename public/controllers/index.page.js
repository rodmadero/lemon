var eventBus = {
    carousel: riot.observable()
};
riot.mixin('event-bus',{events: eventBus});
