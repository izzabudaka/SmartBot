var http = require('http');
var dispatcher = require('httpdispatcher');
var request = require('request');

/*
var getData = function(uri, callback){
  var result;
  request({
      headers: {
        'Authorization' : 'Bearer 2IXWHHCFB2UAYF7L4M7R2O6YN7V3ZN2C'
      },
      uri: uri,
      method: "GET"
    }, function (err, res, body) {
      if (!err && res.statusCode == 200) {
        console.log("Data retrieved successfully\n" + body)
        body = JSON.parse(body)
        var confidence = 0.6          //body.outcomes[0].confidence
        var entities   = { }          //JSON.stringify(body.outcomes[0].entities)
        var intent     = "add_button" //body.outcomes[0].intent
        if(confidence < 0.5) {
          result = "I am " + (confidence * 100) + "% sure that you meant " +
                   intent + " with entities " + entities
                   + " can you please rephrase?"
          console.log(result)
          return JSON.stringify(result)
        } else {
          pushFirebase( { 'intent': intent, 'entities': entities, 'timestamp': Firebase.ServerValue.TIMESTAMP } )
          return "Intent: "+ intent + "\n value: " + entities
        }
      } else{
        console.log("An error occured " + err)
        return JSON.stringify(err);
      }
    });
}*/

function handleRequest(request, response){
    try {
        console.log(request.url);
        dispatcher.dispatch(request, response);
    } catch(err) {
        console.log(err);
    }
}

http.createServer(function (req, res) {
  console.log("Server working!");
  handleRequest(req, res)
}).listen(3000);

dispatcher.setStatic('resources');
   
dispatcher.onPost("/command", function(req, res) {
    res.writeHead(200, {
        'Content-Type':'text/xml'
    });
    res.end(req.body)
});   
