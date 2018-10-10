module.exports = (robot) ->
  robot.respond /help/i, (msg) ->
    @exec = require('child_process').exec
    msg.send "http://gitea.kanakomi.com/typo-master/tech_doc/wiki/bot-help "
