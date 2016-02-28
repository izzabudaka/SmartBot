var express        =        require("express");
var bodyParser     =        require("body-parser");
var app            =        express();
//Here we are configuring express to use body-parser as middle-ware.
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

var Pusher = require('pusher');

var pusher = new Pusher({
  appId: '183673',
  key: '061d40c84c49b423dd49',
  secret: '72146396293da10ca6e0',
  encrypted: true
});
pusher.port = 443;



app.post('/music',function(request,response){
	if(request.body.command == "play"){
		pusher.trigger('macbook', 'music', {
		  "command": "play"
		});
	}
	else{
		pusher.trigger('macbook', 'music', {
		  "command": "stop"
		});
	}
});

app.listen(3000,function(){
  console.log("Started on PORT 3000");
})