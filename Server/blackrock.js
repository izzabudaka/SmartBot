var request    = require('request');
var fs         = require('fs');

this.getRisks = function( callback ) {
  var means = {}
  var countryCount = {}
  getIdentifiers(function(identifiers) {
    getCountries( identifiers, function(countries) {
      getRisk( identifiers, function(risks) {
        for(var i = 0; i < identifiers.length; i++ ){
          if(countries[i] in countryCount)
            countryCount[countries[i]] += 1
          else
            countryCount[countries[i]] = 1
          if(risks[i] == undefined)
            risks[i] = 0
          if(countries[i] in means)
            means[countries[i]] = ((means[countries[i]] * (countryCount[countries[i]] - 1)) + risks[i])/countryCount[countries[i]]
          else
            means[countries[i]] = risks[i]
        }
        callback(means)
      })
    })
  })
}

var getCountries = function(identifier, callback) {
  var url = "https://test3.blackrock.com/tools/hackathon/security-data?identifiers=" + identifier;
  countries = []
  request({
      uri: url,
      method: "GET"
    }, function (err, res, body) {
      var results = JSON.parse(body).resultMap.SECURITY
      for( var i = 0; i < results.length; i++ ) {
        if(results[i].country == undefined)
          results[i].country = "United States"
        countries.push(results[i].country)
      }
      callback(countries)
    });
}

this.stockInfo = function(tickers, attribute, callback) {
  var uri = "https://test3.blackrock.com/tools/hackathon/search-securities?identifiers=" + tickers
  console.log("Using URL: " + uri)
  request({
      headers: {
        'Authorization' : 'Bearer 2IXWHHCFB2UAYF7L4M7R2O6YN7V3ZN2C'
      },
      uri: uri,
      method: "GET"
    }, function (err, res, body) {
      var resultList = JSON.parse(body).resultMap.SEARCH_RESULTS[0].resultList;
      console.log("Retrieved result: " + resultList.toString())
      var result = attribute + " data for: \n"; 
      for( var i = 0; i < resultList.length; i++) {
        result += resultList[i].ticker + " - " + resultList[i][attribute] + "\n"
      }
      console.log(result)
      callback(result)
    });
}

var getRisk = function(identifier, callback) {
  var url = "https://test3.blackrock.com/tools/hackathon/performance?identifiers=" + identifier;
  var risks = [];
  request({
      uri: url,
      method: "GET"
    }, function (err, res, body) {
      var results = JSON.parse(body).resultMap.RETURNS
      for( var i = 0; i < results.length; i++ ) {
        try{
          var dates = Object.keys(results[i].returnsMap)
          risks.push(results[i].returnsMap[dates[dates.length-1]].oneYearRisk)
        } catch(err) {
          console.log(results[i].returnsMap)
        }
        
      }
      callback(risks)
    });
}

var getIdentifiers = function( callback ) {
  var content = fs.readFileSync('identifiers', 'utf8');
  callback(content)
}