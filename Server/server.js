var http       = require('http');
var dispatcher = require('httpdispatcher');
var request    = require('request');
var blackrock  = require('./blackrock.js');
var witai      = require('./witai');
var pusher     = require('./pusherserver.js');
var skyscanner = require('./skyscanner.js');
var riskMap    = {};

function blackRock(message, callback) {
  switch(message.intent.toLowerCase()) {
    case "security_info": 
      blackrock.stockInfo(JSON.parse(message.entities).tickers[0].value, JSON.parse(message.entities).attribute[0].value, function(result) {
        console.log(result)
        callback(result)
      })
      break;
    case "risk":
      var country = JSON.parse(message.entities).country[0].value
      callback("The risk of investing in " + country + " is: " + riskMap[country])
    break;
    case "performance":
      var ticker = JSON.parse(message.entities).ticker[0].value
      blackrock.getPerformance(ticker, function(result) {
        console.log(result)
        callback(result)
      })
    break;
    case "flights":
      var country       = JSON.parse(message.entities).destination[0].value
      var riskCountry   = riskMap[country]
      if( riskCountry == undefined )
        riskCountry = 0.02651179169388535
      var risk        = riskCountry < 0.025? "low" : "high"
      callback("The financial risk associated with travelling to " + country + " is " + riskCountry + " which is " + risk )
    break;
  }
}

function pusher(message, callback) {
  switch(message.intent.toLowerCase()) {
    case "play": 
      pusher.start( function(result) {
        console.log(result)
        callback(result)
      })
    break;
  }
}

function executeCommand(body, callback) {
  try{
    witai.getData(body.message, function(analysedMessage) {
      var to = body.to;
      var services = to.split(',')
      fullResponse = ""
      var serviesNum = services.length
      services.forEach( function(service) {
        console.log(service)
        switch(service) {
          case "blackrock": blackRock(analysedMessage, function(result) {
            fullResponse += result + "\n"
            console.log(result)
            serviesNum--
            if(serviesNum == 0)
              callback(fullResponse)
          })
          break;
          case "pusher": pusher.start( function(result) {
            fullResponse += result + "\n"
            console.log(result)
            serviesNum--
            if(serviesNum == 0)
              callback(fullResponse)
          })
          break;
          case "skyscanner": skyscanner.getData( analysedMessage, function(result) {
            console.log(result)
            fullResponse += result + "\n"
            serviesNum--
            if(serviesNum == 0)
              callback(fullResponse)
          })
          break;
        }      
      })
    })    
  }
  catch(err){
    console.log(err)
    callback("Haha! good joke\n")
  }
}

function handleRequest(request, response){
    try {
        console.log(request.url);
        dispatcher.dispatch(request, response);
    } catch(err) {
        console.log(err);
    }
}
blackrock.getRisks( function(body) {
    riskMap = body
    console.log(body)
})
console.log("Server working!"); 
http.createServer(function (req, res) {
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
