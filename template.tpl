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

const JSONZ = require('JSON');
const queryPermission = require('queryPermission');
const getReferrerUrl = require('getReferrerUrl');
const getUrl = require('getUrl');
const getCookieValues = require('getCookieValues');
const setCookie = require('setCookie');
const getQueryParameters = require('getQueryParameters');
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
  setCookie(data.vName, value, {path: '/', domain: data.defaultDomain, 'max-age': maxAge}, true);
};

var attribuition = function() {
  var search = urlObject.searchParams;
  var clids = searchKeys(search).filter(function(item) { if(item.indexOf('gclid') > -1){return item; } });
  if (clids.length > 0) {
    return JSONZ.stringify({utm_source:'google', utm_medium:'cpc'});
  };

  var _utms = {};
  var utms = searchKeys(search).filter(function(item) {
    if(item.indexOf('utm_') > -1){
      var r =  _utms[item] = search[item];
      return r;
    }
  });

  if (utms.length > 0) { return JSONZ.stringify(_utms); }

  if (typeof(referrer) == 'undefined' || referrer == "") {
    return JSONZ.stringify({utm_source:'__direct__'});
  }

  if (referrer.indexOf('yahoo.com') > - 1 || referrer.indexOf('google.com') > -1 || referrer.indexOf('bing.com') > -1){
    return JSONZ.stringify({utm_source:'__organic__'});
  }

  if (referrer.indexOf('facebook.com') > -1 || referrer.indexOf('instagram.com') > -1 || referrer.indexOf('twitter.com') > -1 || referrer.indexOf('tiktok.com') > -1){
    return  JSONZ.stringify({utm_source:'__social__'});
  }
  if (referrer.indexOf(data.defaultDomain) > -1){
    return;
  }

  referrer = referrer.replace('http://','');
  referrer = referrer.replace('https://','');
  return JSONZ.stringify({utm_source:'referrer/'+ referrer});
}();

if(typeof attribuition !== 'undefined' && attribuition.indexOf('utm_source') > -1){
  attribuition = JSONZ.parse(attribuition);
}

var vNameValue = getCookieValues(data.vName)[0];
if(typeof vNameValue !== 'undefined' && vNameValue.indexOf('utm_source') > -1){
  vNameValue =  JSONZ.parse(vNameValue);
}

if (typeof vNameValue == 'undefined' || vNameValue == '' || !vNameValue || vNameValue.utm_source == '' && (typeof attribuition !== 'undefined')){
   cookie(JSONZ.stringify(attribuition));
   return attribuition;
}

if(typeof attribuition != 'undefined' && attribuition.utm_source != '__direct__' && attribuition.utm_source != vNameValue.utm_source) {
    cookie(JSONZ.stringify(attribuition));
    return attribuition;
}
else {
  if(vNameValue != '' || vNameValue.utm_source != ''){
    return vNameValue;
  }
  return {utm_source: vNameValue.utm_source + '/'+ attribuition.utm_source};
}
return {utm_source: vNameValue.utm_source + '/'+ attribuition.utm_source};


___WEB_PERMISSIONS___

[
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

scenarios:
- name: Test Return Direct
  code: |
    mock('getUrl', component => {
          return url;
        });
    const test = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertThat(test).isDefined();
    assertThat(test.utm_source).contains('__direct');
- name: Test Return Google CPC
  code: |-
    url = 'https://www.example.com/path/?gclid=123123123123123123123#home';
    mock('getUrl', component => {
          return url;
        });
    const test = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertThat(test).isDefined();
    assertThat(test.utm_source).isEqualTo('google');
    assertThat(test.utm_medium).isEqualTo('cpc');
- name: Test Return UTM Mannually
  code: |
    url = 'https://www.example.com/path/?utm_source=test&utm_medium=test2#home';
    mock('getUrl', component => {
          return url;
        });
    const test = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertThat(test).isDefined();
    assertThat(test.utm_source).isEqualTo('test');
    assertThat(test.utm_medium).isEqualTo('test2');
- name: Test Return Social
  code: |-
    url = 'https://www.example.com/path/#home';
    mock('getUrl', component => {
          return url;
        });
    const referrer = 'https://www.facebook.com/';
    mock('getReferrerUrl', component => {
          return referrer;
        });

    const test = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getReferrerUrl').wasCalled();
    assertThat(test).isDefined();
    assertThat(test.utm_source).contains('__social');
- name: Test Return Organic
  code: |
    url = 'https://www.example.com/path/#home';
    mock('getUrl', component => {
          return url;
        });

    const referrer = 'https://www.google.com/';
    mock('getReferrerUrl', component => {
          return referrer;
        });

    const test = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getReferrerUrl').wasCalled();
    assertThat(test).isDefined();
    assertThat(test.utm_source).contains('__organic');
- name: Test Return External Referrer
  code: |
    url = 'https://www.example.com/path/#home';
    mock('getUrl', component => {
          return url;
        });

    const referrer = 'https://www.previous.com/';
    mock('getReferrerUrl', component => {
          return referrer;
        });

    const test = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getReferrerUrl').wasCalled();
    assertThat(test).isDefined();
    assertThat(test.utm_source).contains('referrer');
- name: Test Return Internal Referrer
  code: |
    url = 'https://www.example.com/path/#home';
    mock('getUrl', component => {
          return url;
        });

    const referrer = 'https://www.example.com/path/#about';
    mock('getReferrerUrl', component => {
          return referrer;
        });

    const test = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getReferrerUrl').wasCalled();
    assertThat(test).isUndefined();
- name: Test SetCookie Value
  code: |-
    mock('getUrl', component => {
      return url;
    });
    let val = '';
    mock('setCookie', (name, value, options) => {
      if (name !== mockData.vName) fail('Cookie name not set');
      if (options['max-age'] !== 60*60*24*mockData.cookieExpDays) fail('Cookie expire days not set');
      if (options.domain !== mockData.defaultDomain) fail('Cookie domain not set');
      val = value;
    });

    const test = runCode(mockData);

    assertApi('setCookie').wasCalled();
    assertThat(test).isDefined();
    assertThat(test.utm_source).contains('__direct');
setup: |-
  const mockData = {
    defaultDomain: '.example.com',
    vName:'origemMTZ',
    cookieExpDays: '30'
  };
  let url = 'https://www.example.com/path/#home';


___NOTES___

Created on 03/05/2023, 14:08:02
