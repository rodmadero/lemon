var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var main = require('./server/routes/main');

app.set('view engine', 'ejs');

app.use('/node_modules', express.static('node_modules'));
app.use('/bower_components', express.static('bower_components'));

app.get('/',main.home);

io.on('connection',function(socket){
	socket.on('message',function(msg){
		io.emit('message',msg);
	});
});

http.listen(3000,function(){
	console.log('App started on port 3000!');
});
