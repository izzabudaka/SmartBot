var request    = require('request');
var witUri     = 'https://api.wit.ai/message?v=20160227&q='

this.getData = function(uri, callback){
  var result;
  request({
      headers: {
        'Authorization' : 'Bearer 65QAGSK6W6BBUEGZYDBQO2EXYHKJK2LT'
      },
      uri: witUri + uri,
      method: "GET"
    }, function (err, res, body) {
      if (!err && res.statusCode == 200) {
        console.log("Data retrieved successfully\n" + body)
        body = JSON.parse(body)
        var confidence = body.outcomes[0].confidence
        var entities   = JSON.stringify(body.outcomes[0].entities)
        var intent     = body.outcomes[0].intent
        if(confidence < 0.5) {
          result = "I am " + (confidence * 100) + "% sure that you meant " +
                   intent + " with entities " + entities
                   + " can you please rephrase?"
          console.log(result)
        } else {
          console.log( 'intent: ' + intent + '-entities: '+entities )
          callback( { 'intent': intent, 'entities': entities } )
        }
      } else{
        console.log("An error occured " + err)
      }
    });
}