# Description:
# Commands:
#  hubot ping <hostname>

module.exports = (robot) ->
  robot.respond /list/i, (msg) ->
    @exec = require('child_process').exec
    command1 = "grep hear /data/decadebot/scripts/* | awk -F\":\" '{print $2}'| grep -v command |sed -e \"s/^ *//\""
    command2 = "grep respond /data/decadebot/scripts/* | awk -F\":\" '{print $2}'| grep -v command | sed -e \"s/^ *//\""

    #msg.send command1
    @exec command1, (error, stdout, stderr) ->
      msg.send stdout

    #msg.send command2
    @exec command2, (error, stdout, stderr) ->
      msg.send stdout

