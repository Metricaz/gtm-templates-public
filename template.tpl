___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Set Atribuition Params Persistent Cookie (by Metricaz)",
  "description": "Variable to set cookie persist of campaign information params and return itself in a session or in window attribution",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "LABEL",
    "name": "Variable Name",
    "displayName": ""
  },
  {
    "type": "TEXT",
    "name": "vName",
    "displayName": "Variable Name",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "STRING_LENGTH",
        "args": [
          2,
          25
        ]
      }
    ],
    "valueHint": "origemMTZ"
  },
  {
    "type": "LABEL",
    "name": "Default Domain",
    "displayName": ""
  },
  {
    "type": "TEXT",
    "name": "defaultDomain",
    "displayName": "Main default domain",
    "simpleValueType": true,
    "valueHint": "domain.com",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "STRING_LENGTH",
        "args": [
          2
        ]
      }
    ]
  },
  {
    "type": "LABEL",
    "name": "Cookie Expiration Days",
    "displayName": ""
  },
  {
    "type": "TEXT",
    "name": "cookieExpDays",
    "displayName": "Days to expirate (attribuition window)",
    "simpleValueType": true,
    "valueHint": "30 (days)",
    "help": "Keep without value if you want use session or define days"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const JSON = require('JSON');
const queryPermission = require('queryPermission');
const getReferrerUrl = require('getReferrerUrl');
const getUrl = require('getUrl');
const getCookieValues = require('getCookieValues');
const setCookie = require('setCookie');
const getQueryParameters = require('getQueryParameters');
const decodeUriComponent = require('decodeUriComponent');
const parseUrl = require('parseUrl');

var referrer  = getReferrerUrl(undefined);
var url = getUrl(undefined);
var  urlObject = parseUrl(url);

var searchKeys = function(obj){
  var keys = [];
  for (var key in obj) {
    keys.push(key);
    }
  return keys;
};

var cookie = function(value){
  var maxAge = (data.cookieExpDays)?60*60*24*data.cookieExpDays:'';
  setCookie(data.vName, value, {'path': '/', 'domain': data.defaultDomain, 'max-age': maxAge}, true);
};

var attribuition = function() {
  var search = urlObject.searchParams;
  var clids = searchKeys(search).filter(function(item) { if(item.indexOf('gclid') > -1){return item; } });
  if (clids.length > 0) {
    //log("gclid is google cpc");
    return JSON.stringify({'utm_source':'google', 'utm_medium':'cpc'});
  }

  var _utms = {};
  var utms = searchKeys(search).filter(function(item) {
    if(item.indexOf('utm') > -1){
      return _utms[item] = search[item];
    }
  });

  if (utms.length > 0) { return JSON.stringify(_utms); }

  if (typeof(referrer) == 'undefined' || referrer == "") {
    //log("referrer undefined"); // dlme
    return JSON.stringify({'utm_source':'__direct__'});
  }

  if (referrer.indexOf('yahoo.com') > -1 || referrer.indexOf('google.com') > -1 || referrer.indexOf('bing.com') > -1){
    //log("referrer is search engine"); // dlme
    return JSON.stringify({'utm_source':'__organic__'});
  }

  if (referrer.indexOf('facebook.com') > -1 || referrer.indexOf('instagram.com') > -1 || referrer.indexOf('twitter.com') > -1 || referrer.indexOf('tiktok.com') > -1){
    //log("referrer is social media"); // dlme
    return  JSON.stringify({'utm_source':'__social__'});
  }

  if (referrer.indexOf(data.defaultDomain > 0)){
    //log("defaultdomain is present");//dlme
    return;
  }

  referrer = referrer.replace('http://','');
  referrer = referrer.replace('https://','');
  return JSON.stringify({'utm_source':'referrer/'+ referrer});
}();

attribuition = JSON.parse(attribuition);
//log("Attribuition variable"); //dlme
//log(attribuition);//dlme

var vNameValue = getCookieValues(data.vName);
//log("vNameValue:");//dlme
//log(vNameValue);//dlme
vNameValue =  JSON.parse(vNameValue);

if (typeof vNameValue == 'undefined' || vNameValue == '' || !vNameValue || vNameValue.utm_source == '' && (typeof attribuition !== 'undefined')){
   cookie(JSON.stringify(attribuition));
   //log('first cookie'); //dlme
   return attribuition;
}

if(typeof attribuition != 'undefined' && attribuition.utm_source != '__direct__' && attribuition.utm_source != vNameValue.utm_source) {
    cookie(JSON.stringify(attribuition));
    //log('redefine cookie');
    return attribuition;
}
else {
  if(vNameValue != '' || vNameValue.utm_source != ''){
    return vNameValue;
  }
  //log('return cookie');
  return {'utm_source':vNameValue.utm_source + '/'+ attribuition.utm_source};
}
return {'utm_source':vNameValue.utm_source + '/'+ attribuition.utm_source};


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_referrer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 03/05/2023, 14:08:02
