mongo = require 'mongoskin'

module.exports =
  init: (db = 'localhost:27017/devhead', collection_name = 'resources') ->
    @db = mongo.db(db)
    @resources = @db.collection(collection_name)
  all: (cb) ->
    @resources.find().toArray cb
  search: (q, cb) ->
    re = new RegExp("#{q}")
    @resources.find( $or : [{name: re }, {link: re }, {tags: re }, {resource_type: re }]).toArray cb
  add: (resource, cb) ->
    resource.comments = []
    @resources.insert resource, cb
  edit: (id, resource, cb) ->
    @resources.findAndModify { _id: @resources.id(id) },
      [],
      { $set: resource },
      new: false,
      cb
  get: (id, cb) ->
    @resources.findById id, cb
  remove: (id, cb) ->
    @resources.removeById id, cb
  addComment: (id, comment, cb) ->
    @resources.findAndModify { _id: @resources.id(id) },
      [],
      { $push: comments: comment}, 
      new: true,
      cb
      
    