var Pusher = require('pusher-client');

var Player = require('player');
 
	// create player instance 
var player = new Player('./song.mp3');


var pusher = new Pusher("061d40c84c49b423dd49");
var my_channel = pusher.subscribe('macbook');
my_channel.bind('music',
  function(data) {
    console.log(data);
    
	 if(data.command == "play"){
		player.play();
	 }
	 else{
	 	player.stop();
	 }	
  }
);