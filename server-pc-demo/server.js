var Pusher = require('pusher-client');
var pusher = new Pusher("061d40c84c49b423dd49", {
    secret: '72146396293da10ca6e0'
});

var channel = pusher.subscribe('macbook');
channel.bind('music',
  function(data) {
    console.log(data)
  }
);