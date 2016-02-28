var Pusher = require('pusher-client');
var player = require('play-sound')(opts= {})

var pusher = new Pusher('08dc3c1210124745e53e', {
        encrypted: true
});

var channel = pusher.subscribe('my-channel');

channel.bind('my-event', function(data) {
    player.play(data.music),
    function(err){}
});