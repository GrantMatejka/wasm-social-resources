const connect = require('connect');
const serveStatic = require('serve-static');

connect().use(serveStatic(__dirname + "/"))
  .listen(8080, function() {
    console.log("localhost:8080");
  });