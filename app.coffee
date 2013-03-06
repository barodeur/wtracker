require 'newrelic' if process.env.NODE_ENV == 'production'
express = require 'express'
mongoose = require 'mongoose'
crypto = require 'crypto'

mongoUri = process.env.MONGOHQ_URL || 'mongodb://localhost/wtracker_development'
mongoose.connect mongoUri

# Models
Record = mongoose.model 'Record', mongoose.Schema(
  value: Number
  date:
    type: Date
    default: Date.now
)

app = express()
app.use express.bodyParser()

auth = express.basicAuth (user, pass) ->
  pass == process.env.PASSWORD

app.get '/records/last', auth, (req, res) ->
  lastRecord = Record.findOne().sort('-date').exec (err, record) ->
    if err
      res.status 500
      res.end()
    else
      return res.end 'no result' unless record
      res.end "date: #{record.date}\nvalue: #{record.value}"

app.post '/track', (req, res) ->
  hmac = crypto.createHmac 'SHA256', process.env.MAILGUN_API_KEY
  hmac.update "#{req.body.timestamp}#{req.body.token}"
  if hmac.digest('hex') == req.body.signature
    value = req.body['stripped-text']
    console.log "Receive email from #{req.body.from} with value #{value}"

    record = new Record(value: value)
    record.save (err) ->
      if err
        res.status 500
      else
        res.status 201

  res.end()

app.listen process.env.PORT || 3000
