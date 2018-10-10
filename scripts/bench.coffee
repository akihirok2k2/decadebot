# Description:

module.exports = (robot) ->
  robot.respond /bench|ベンチ/, (msg) ->
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
          msg.send "さて、どのくらいのものか" + vmname + "試してやろう"
          command = "sudo bash /usr/local/bin/decade/bench-send.sh " + vmname 
          #msg.send "Command: #{command}"
          @exec command, (error, stdout, stderr) ->
            #msg.send error if error?
            #msg.send stdout if stdout?
            #msg.send stderr if stderr?
            #msg.send "```[ root@ansible ~]# ssh-keygen -R " + vmname + ".kanakomi.com \n[ root@ansible ~]# ssh root@" + vmname + ".kanakomi.com``` " 
        else
            msg.send "おのれディケイドオオオオオオオオオオオオ！！！"
                                                      


