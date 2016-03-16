#!/bin/bash

#WEBSERVER APP.JS / NODEJS
cat > ~ubuntu/app.js << "EOF"
var http = require('http');
var server = http.createServer(function (request, response) {  response.writeHead(200, {"Content-Type": "text/plain"});
response.end("Hello World\n");
});
server.listen(8080);
console.log("Server running at http://127.0.0.1:8080/");
EOF
su - ubuntu -c "pm2 start ~ubuntu/app.js"
su - ubuntu -c "pm2 save"

