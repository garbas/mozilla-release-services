'use strict';

require('expose?$!expose?jQuery!jquery');
require('expose?Tether!tether');
require('bootstrap');
var Hawk = require('hawk');
require("./index.scss");

var backend_dashboard_url = process.env.NEO_DASHBOARD_URL || "http://localhost:5000";
//console.info('Dashboard backend used ', backend_dashboard_url);

var storage_key = 'shipit-credentials';

// Start the ELM application
var url = require('url');
var app = require('./Main.elm').Main.fullscreen({
  backend_dashboard_url: backend_dashboard_url
});

// Local storage ports
app.ports.localstorage_load.subscribe(function(){
  // Load credentials from local storage
  var user = null;
  try {
    user = JSON.parse(window.localStorage.getItem(storage_key));
    user = user.value || user;
    user.hawkHeader = null;
    //console.info('Loaded user', user);
  } catch (e) {
    //console.warn('Loading user failed', e);
  }
  app.ports.localstorage_get.send(user);
});

app.ports.localstorage_remove.subscribe(function() {
  window.localStorage.removeItem(storage_key);
  app.ports.localstorage_get.send(null);
});

app.ports.localstorage_set.subscribe(function(user) {
  user = user ? user.value : null;
  window.localStorage.setItem(storage_key, JSON.stringify(user));
  app.ports.localstorage_get.send(user);
});

// HAWK auth
app.ports.hawk_build.subscribe(function(request){
  var url = backend_dashboard_url + request.url; // TODO: use direct request.url
  var header = Hawk.client.header(url, request.method, {
    credentials: {
      id: request.user.clientId,
      key: request.user.accessToken,
      algorithm: 'sha256'
    },
    ext: new Buffer(JSON.stringify({certificate: request.user.certificate})).toString('base64'),
  });
  app.ports.hawk_get.send(header.field);
});

app.ports.redirect.subscribe(function(redirect) {
   var redirect_url = url.parse(redirect.url);
   if (redirect.target !== null) {
     redirect_url = url.format(window.$.extend({}, redirect_url, {
       query: {
         target: url.format({
             protocol: window.location.protocol,
             host: window.location.host,
             port: window.location.port,
             pathname: redirect.target[0]
         }),
         description: redirect.target[1]
       }
     }));
   } else {
     redirect_url = url.format(redirect_url)
   }
   window.location = redirect_url;
});