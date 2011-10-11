(function() {
  var mongo;
  mongo = require('mongoskin');
  module.exports = {
    init: function(db, collection_name) {
      if (db == null) {
        db = 'localhost:27017/devhead';
      }
      if (collection_name == null) {
        collection_name = 'resources';
      }
      this.db = mongo.db(db);
      return this.resources = this.db.collection(collection_name);
    },
    all: function(cb) {
      return this.resources.find().toArray(cb);
    },
    search: function(q, cb) {
      var re;
      re = new RegExp("" + q);
      return this.resources.find({
        $or: [
          {
            name: re
          }, {
            link: re
          }, {
            tags: re
          }, {
            resource_type: re
          }
        ]
      }).toArray(cb);
    },
    add: function(resource, cb) {
      resource.comments = [];
      return this.resources.insert(resource, cb);
    },
    edit: function(id, resource, cb) {
      return this.resources.findAndModify({
        _id: this.resources.id(id)
      }, [], {
        $set: resource
      }, {
        "new": false
      }, cb);
    },
    get: function(id, cb) {
      return this.resources.findById(id, cb);
    },
    remove: function(id, cb) {
      return this.resources.removeById(id, cb);
    },
    addComment: function(id, comment, cb) {
      return this.resources.findAndModify({
        _id: this.resources.id(id)
      }, [], {
        $push: {
          comments: comment
        }
      }, {
        "new": true
      }, cb);
    }
  };
}).call(this);
