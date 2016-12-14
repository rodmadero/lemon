var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var index = require('./server/routes/index');

app.set('view engine', 'ejs');

app.use('/node_modules', express.static('node_modules'));
app.use('/bower_components', express.static('bower_components'));
app.use('/public', express.static('public'));

app.locals.dependencies = {
	js: [
		'/node_modules/socket.io-client/socket.io.js',
		'/bower_components/jquery/dist/jquery.js',
		'/bower_components/bootstrap/dist/js/bootstrap.js',
		'/bower_components/riot/riot+compiler.js'
	],
	css: [
		'/bower_components/bootstrap/dist/css/bootstrap.css',
		'/public/css/index.css'
	],
	tags: [
		'/public/tags/dial.tag'
	]
};
app.locals.title = 'Lets make a dial';

app.get('/',index.home);

io.on('connection',function(socket){
	socket.on('dot-added',function(options){
		socket.broadcast.emit('dot-added',options);
	});
});

http.listen(3000,function(){
	console.log('App started on port 3000!');
});
