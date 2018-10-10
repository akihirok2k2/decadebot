# Description:

module.exports = (robot) ->
  robot.respond /(start|stop|restart|起動|停止|再起動)/i, (msg) ->
      @exec = require('child_process').exec
      if msg.message.match(/vm01/)
        vmname = "vm01"
      else if msg.message.match(/vm02/)
        vmname = "vm02"
      else if msg.message.match(/vm03/)
        vmname = "vm03"
      else if msg.message.match(/test-vm/)
        vmname = "test-vm"
      if vmname?
        if msg.message.match(/restart|再起動/)
          action = "restart"
        else if msg.message.match(/start|起動/)
          action = "start"
        else if msg.message.match(/stop|停止/)
          action = "stop"
        if action?
          msg.send  vmname + "の" + action + "か。ちょっと待ってろ"
          command = "sudo bash /usr/local/bin/decade/vmact.sh " + vmname + " " + action
          @exec command, (error, stdout, stderr) ->
            #msg.send error if error?
            #msg.send stdout if stdout?
            #msg.send stderr if stderr?
            msg.send vmname + "の" + action + "は完了した。ここも俺の世界じゃないみたいだ" 
        else
          msg.send "おのれディケイドオオオオオオオオオオオオ！！！"
      else
        msg.send "おのれディケイドオオオオオオオオオオオオ！！！"
