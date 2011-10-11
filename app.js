(function() {
  var app, express;
  express = require("express");
  app = module.exports = express.createServer();
  app.resources = require('./resources');
  app.configure(function() {
    app.set("views", __dirname + "/views");
    app.set("view engine", "jade");
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(express.static(__dirname + "/public"));
  });
  app.configure("development", function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  app.configure("production", function() {
    return app.use(express.errorHandler());
  });
  app.get("/", function(req, res) {
    var results;
    results = function(err, resources) {
      return res.render("index", {
        title: "devHead",
        resources: resources
      });
    };
    if (req.query && req.query.q) {
      return app.resources.search(req.query.q, results);
    } else {
      return app.resources.all(results);
    }
  });
  app.get("/resources/new", function(req, res) {
    return res.render("resources/new", {
      title: "devHead - New Resource",
      types: ['book', 'video', 'talk', 'screencast', 'podcast', 'site', 'code']
    });
  });
  app.post("/resources", function(req, res) {
    return app.resources.add(req.body, function(err, resource) {
      return res.redirect('/');
    });
  });
  app.get("/resources/:id/edit", function(req, res) {
    return app.resources.get(req.params.id, function(err, resource) {
      resource.types = ['book', 'video', 'talk', 'screencast', 'podcast', 'site', 'code'];
      return res.render("resources/edit", resource);
    });
  });
  app.get("/resources/:id", function(req, res) {
    return app.resources.get(req.params.id, function(err, resource) {
      return res.render("resources/show", resource);
    });
  });
  app.post("/resources/:id/comments", function(req, res) {
    return app.resources.addComment(req.params.id, req.body, function(err, resource) {
      return res.render("resources/show", resource);
    });
  });
  app.put("/resources/:id", function(req, res) {
    return app.resources.edit(req.params.id, req.body, function(err, resource) {
      return res.redirect("/");
    });
  });
  app.listen(process.env.PORT || 3000, function() {
    app.resources.init(process.env.MONGOHQ_URL || 'localhost:27017/devhead');
    return console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
  });
}).call(this);
