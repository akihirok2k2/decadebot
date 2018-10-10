# Description:

module.exports = (robot) ->
  robot.respond /再インストール|reinstall/, (msg) ->
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
        if msg.message.match(/centos7/i)
          dist = "centos7"
        else if msg.message.match(/centos6/i)
          dist = "centos6"
        else 
          dist = "ubuntu1604"
        if dist?
          msg.send "ここが" + vmname + "の世界か。" + dist + " になるまで1分ほど待ってろ"
          command = "sudo bash /usr/local/bin/decade/reinst.sh " + vmname + " " + dist
          #msg.send "Command: #{command}"
          @exec command, (error, stdout, stderr) ->
            #msg.send error if error?
            #msg.send stdout if stdout?
            #msg.send stderr if stderr?
            msg.send vmname + "のOS再インストール(" + dist + ")が終わった。ここも俺の世界じゃないみたいだ。以下のコマンドでも実行するんだな" 
            msg.send "```[ root@ansible ~]# ssh-keygen -R " + vmname + ".kanakomi.com \n[ root@ansible ~]# ssh root@" + vmname + ".kanakomi.com``` " 
        else
            msg.send "おのれディケイドオオオオオオオオオオオオ！！！"
                                                      


