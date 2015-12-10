express = require 'express'
util = require 'util'
co = require 'co'
Promise = require 'bluebird'
bodyparser = require 'body-parser'
config = require 'config'
https = require 'https'
querystring = require 'querystring'
URL = require 'url'
ChildProcess = require 'child_process'

https_post = (url, params) ->
  postData = JSON.stringify(params)
  url = URL.parse(url)
  new Promise (rs, rj) ->
    response = ""
    options =
      hostname: url.hostname
      path: url.path
      method: "POST"
      headers:
        "Content-Type": "application/json"
    req = https.request options, (res) ->
      res.setEncoding("utf8")
      res.on "data", (d) ->
        response += d
      res.on "end", ->
        rs response

    req.on "error", (e) -> rj e
    req.write postData
    req.end()

app = express()

app.use bodyparser.urlencoded(extended: true)
app.use bodyparser.json()

# routes
# listen on trello hook
app.post "/trello_notification", (req, res) ->
  co ->
    console.log JSON.stringify(req.body, null, 2)
    res.send ok: true
  .catch (err) ->
    console.error err
    res.status(500).send err.message

# listen on github hook
app.post "/github_notification", (req, res) ->
  co ->
    console.log JSON.stringify(req.body, null, 2)
    res.send ok: true
  .catch (err) ->
    console.error err
    res.status(500).send err.message

port = process.env.PORT || 9000
server = app.listen parseInt(port), ->
  console.log "app listening.."
