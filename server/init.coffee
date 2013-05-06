###
# This is main server file
# bootstrap configuration and routes
###
"use strict"
express = require "express"
logger = require "../server/common/logger"
logger.defaults
    level: 5
    name: "Main"

log = logger.create name: "Server"

app = express()
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'

app.locals.pretty = true

app.use express.errorHandler()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.methodOverride()
app.use express.static(__dirname + '/../web')

app.get "/", (req, res) ->
    res.render "main"

port =  process.env.PORT || process.env["PORT_WWW"]  || 3000

app.listen port, ->
    log.info "Listening on #{port}"

app.on "close", ->
    done()