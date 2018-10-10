# What is decadebot?
基本的にはクラウド上のVMを操作するためのbotである。
 #bot_test チャンネルに生息してます。

scriptはこちら　http://gitea.kanakomi.com/typo-master/decadebot
## ベンチマーク実行
対象VM内に設置してあるベンチマークスクリプトをたたきます。
実行のためには条件がいくつかあります。
・対象VMに/root/bench.shが設置してあること
・ansibleから対象VMにSSHできること
```
@世界の破壊者 bench vm01 
or
@世界の破壊者 ベンチ vm01 
```


## OS再インストール
ディストリビューションは指定してなかったらUbutnu16.04が入ります
```
@世界の破壊者 reinstall vm01 [centos6/centos7/ubuntu1604]
or
@世界の破壊者 再インストール vm01 [centos6/centos7/ubuntu1604]
```

## 電源操作
### VMの強制停止
```
@世界の破壊者 stop vm01 
or 
@世界の破壊者 停止 vm01
```

### VMの起動
```
@世界の破壊者 start vm01
or 
@世界の破壊者 起動 vm01
```

### VMの強制再起動
```
@世界の破壊者 restart vm01
or 
@世界の破壊者 再起動 vm01
```


