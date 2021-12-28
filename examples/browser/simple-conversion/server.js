const connect = require('connect');
const serveStatic = require('serve-static');

connect().use(serveStatic(__dirname + "/"))
  .listen(8081, function() {
    console.log("localhost:8081");
  });