express = require("express")
app = module.exports = express.createServer()

app.resources = require './resources'


app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", (req, res) ->
  results = (err, resources) ->    
    res.render "index", title: "devHead", resources: resources
  if req.query and req.query.q
    app.resources.search req.query.q, results
  else
    app.resources.all results

app.get "/resources/new", (req, res) ->
  res.render "resources/new", title: "devHead - New Resource", types: ['book', 'video', 'talk', 'screencast', 'podcast', 'site', 'code']

app.post "/resources", (req, res) ->
  app.resources.add req.body, (err, resource) ->
    res.redirect '/'

app.get "/resources/:id/edit", (req, res) ->
  app.resources.get req.params.id, (err, resource) ->
    resource.types = ['book', 'video', 'talk', 'screencast', 'podcast', 'site', 'code']
    res.render "resources/edit", resource

app.get "/resources/:id", (req, res) ->
  app.resources.get req.params.id, (err, resource) ->
    res.render "resources/show", resource

app.post "/resources/:id/comments", (req, res) ->
  app.resources.addComment req.params.id, req.body, (err, resource) ->
    res.render "resources/show", resource

app.put "/resources/:id", (req, res) ->
  app.resources.edit req.params.id, req.body, (err, resource) ->
    res.redirect "/"

app.listen process.env.PORT || 3000, ->
  app.resources.init process.env.MONGOHQ_URL ||'localhost:27017/devhead' 
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env