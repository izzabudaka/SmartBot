var request       = require('request');
var skyScannerURL = 'http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/UK/GBP/en-GG/origin/destination/fromDate/toDate?apiKey=prtl6749387986743898559646983194'
var places        = {
  'france':         'FR',
  'london':         'LON',
  'united kingdom': 'UK',
  'united states':  'US',
  'spain':          'ES',
  'manchester':     'MAN',
}

function getCountryCode( country ) {
  return places[country.toLowerCase()]
}

function normaliseTravelInfo(message, callback) {
  travelInfo = {}
  var entities = JSON.parse(message.entities)
  if( entities.destination[0].value == undefined )
    travelInfo['destination'] = 'FR'
  else
    travelInfo['destination'] = getCountryCode(entities.destination[0].value)
  if( entities.origin[0].value == undefined )
    travelInfo['origin'] = 'LON'
  else
    travelInfo['origin'] = getCountryCode(entities.origin[0].value)
  travelInfo['fromDate']    = 'anytime'
  travelInfo['toDate']      = 'anytime'
  console.log(entities.origin[0].value)
  callback(travelInfo)
}

var constructUrl = function(travelInfo, callback) {
  var url = skyScannerURL.replace( 'origin', travelInfo.origin )
            .replace( 'destination', travelInfo.destination )
            .replace( 'fromDate', travelInfo.fromDate )
            .replace( 'toDate', travelInfo.toDate )
  console.log(url)
  callback(url)
}

this.getData = function(message, callback){
  normaliseTravelInfo(message, function(travelInfo) {
    constructUrl( travelInfo, function(url) {
      request({
          uri: url,
          method: "GET"
        }, function (err, res, body) {
          var result = JSON.parse(body) 
          var price  = result.Quotes[0].MinPrice 
          var time   = result.Quotes[0].OutboundLeg.DepartureDate
          var d = new Date(time);
          callback("You can leave at " + d + " for £" + price)
        });
    })
  })
}