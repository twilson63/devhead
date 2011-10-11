require __dirname + '/../../app.js'
zombie = require 'zombie'
url = 'http://localhost:3000/'

visit_index_page = (cb) ->
  zombie.visit url, (err, browser) -> cb(browser)

describe '#index', ->
  it 'title equals devhead', ->
    visit_index_page (browser) ->
      expect(browser.text('title')).toEqual('devHead')
      asyncSpecDone()
    asyncSpecWait()
  it 'has search form', ->
    visit_index_page (browser) ->
      browser.
        fill('q', 'hello').
        pressButton 'Search', (err, browser) ->
          expect(browser.location.toString()).toEqual('http://localhost:3000/?q=hello')
          asyncSpecDone()
    asyncSpecWait()
      
  it 'has add button', ->
    visit_index_page (browser) ->
      browser.clickLink 'Add', (err, browser) ->
        expect(browser.text('h3')).toEqual('New Resource')
        asyncSpecDone()
    asyncSpecWait()