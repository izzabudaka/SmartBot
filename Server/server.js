var http       = require('http');
var dispatcher = require('httpdispatcher');
var request    = require('request');
var blackrock  = require('./blackrock.js');
var witai      = require('./witai');

function blackRock(message, callback) {
  switch(message.intent.toLowerCase()) {
    case "security_info": 
      blackrock.stockInfo(JSON.parse(message.entities).tickers[0].value, JSON.parse(message.entities).attribute[0].value, function(result) {
        console.log(result)
        callback(result)
      })
      break;
    case "risk":
      blackrock.getRisks( function(body) {
        var country = JSON.parse(message.entities).country[0].value
        console.log(body[country])
        callback("The risk of investing in " + country + " is: " + body[country])
      })
    break;

  }
}

function executeCommand(body, callback) {
  witai.getData(body.message, function(analysedMessage) {
    var to = body.to;
    switch(to.toLowerCase()) {
      case "blackrock": blackRock(analysedMessage, function(result) {
        callback(result)
      })
      break;
    }
  })
}

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
}).listen(8007);

dispatcher.setStatic('resources');

dispatcher.onPost("/risk", function(req, res) {
    res.writeHead(200, {
        'Content-Type':'text/xml'
    });
    blackrock.getRisks( function(body) {
      console.log(body[req.body])
      res.end("The risk of investing in " + req.body + " is: " + body[req.body])
    })
}); 

dispatcher.onPost("/command", function(req, res) {
    res.writeHead(200, {
        'Content-Type':'text/xml'
    });
    console.log(req.body)
    executeCommand(JSON.parse(req.body), function(body) {
      res.end(body)
    })
});   
