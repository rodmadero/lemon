$(document).ready(function(){
	$(document.body).click(function(e){
		var options = {
			top: e.clientY, 
			left: e.clientX,
			color: getRandomColor(),
			size: getInt(10,500)
		};
		addDot(options);
		socket.emit('dot-added',options);
	});

	socket.on('dot-added',function(options){
		addDot(options);
	});
});

var socket = io();

var addDot = function(options) {
	var dot = document.createElement('div');
	$(document.body).append(dot);

	dot.style.position = 'absolute';
	dot.style.top = (options.top - (options.size/2))+'px';
        dot.style.left = (options.left - (options.size/2))+'px';
        dot.style.height = options.size+'px';
        dot.style.width = options.size+'px';
	dot.style.borderRadius = options.size+'px';
	dot.style.opacity = '0.5';
        dot.style.backgroundColor = options.color;	
};

var getInt = function(min,max) {
	max = max || 100;
	min = min || 1;

	return Math.floor(Math.random()*(max-min+1)+min);
};

function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}
