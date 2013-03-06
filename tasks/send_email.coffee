nodemailer = require 'nodemailer'

smtpTransport = nodemailer.createTransport 'SMTP',
  host: process.env.MAILGUN_SMTP_SERVER
  port: process.env.MAILGUN_SMTP_PORT
  auth:
    user: process.env.MAILGUN_SMTP_LOGIN
    pass: process.env.MAILGUN_SMTP_PASSWORD

smtpTransport.sendMail
  to: process.env.PERSONAL_EMAIL
  from: process.env.MAILGUN_SMTP_LOGIN
  replyTo: process.env.TRACKING_ADDRESS
  subject: "Quel poids aujourd'hui ?"
  text: ''
  (err, response) ->
    if err
      processExit = 1
      console.error "Can't send email"
    else
      processExit = 0
      console.log "Email sent successfully"
    smtpTransport.close()
