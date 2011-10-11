require __dirname + '/../../../app.js'
zombie = require 'zombie'
url = 'http://localhost:3000/resources/new'

visit_new_resource = (cb) ->
  zombie.visit url, (err, browser) -> cb(browser)

describe '#index', ->
  it 'h3 equals devhead', ->
    visit_new_resource (browser) ->
      expect(browser.text('h3')).toEqual('New Resource')
      asyncSpecDone()
    asyncSpecWait()
  it 'create new resource', ->
    visit_new_resource (browser) ->
      browser.
        fill('name', 'Tom Wilson BarCampCHS Ruby 101').
        fill('link', 'http://google.com').
        choose('talk').
        fill('tags', 'ruby').
        pressButton 'Create Resource', (err, browser) ->
          expect(browser.location.toString()).toEqual('http://localhost:3000/')
          asyncSpecDone()
    asyncSpecWait()
  #     
  # it 'has add button', ->
  #   visit_index_page (browser) ->
  #     browser.clickLink 'Add', (err, browser) ->
  #       expect(browser.text('h3')).toEqual('New Resource')
  #       asyncSpecDone()
  #   asyncSpecWait()