var Pusher = require('pusher');

var pusher = new Pusher({
  appId: '183563',
  key: '08dc3c1210124745e53e',
  secret: '959d262cb74a17591cf1',
  encrypted: true
});
pusher.port = 443;

var trigger = function() {
    pusher.trigger('my-channel',
    'my-event', {
        "music": "../Music/wreckingball.m4a"
    });
}

this.start = function( callback ) {
  setInterval(trigger, 3000);
  callback("Triggered!")
}
