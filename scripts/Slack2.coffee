# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
    # Slack API
    token = "xoxb-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    Slack = require 'slack-node'
    slack = new Slack token

    fs = require('fs')

    # 平日の23時55分に定期実行
    Cron = require('cron').CronJob
    cronJob = new Cron '0 50 23 * * 1-5', ->
        outputLog()

    cronJob.start()

    # ログ出力メソッド
    outputLog = ->
        # archiveチャンネルは除外
        channelsListParams = {exclude_archived: 1}

        getChannelsList channelsListParams, (channels) ->
            userListParams = {}

            getUserList userListParams, (members) ->
                # oldestに指定するタイムスタンプ
                todayTs = getTodayTimeStamp()

                for channelId, channel of channels
                    historyParams = {channel: "#{channelId}", oldest: todayTs, count: 1000}
                    getHistory historyParams, (messages, params) ->
                        roomName = channels["#{params.channel}"].name
                        now = new Date()
                        folderPath = "./#{now.getFullYear()}#{now.getMonth() + 1}#{now.getDate()}"
                        fileName = "#{roomName}.log"

                        # フォルダ作成
                        if !fs.existsSync(folderPath)
                            fs.mkdirSync(folderPath)

                        # ファイル書き込み
                        for message in messages
                            # イベントは無視
                            if message.type is "message"
                                userName = members["#{message.user}"].name
                                time = getTime message.ts

                                fs.appendFileSync "#{folderPath}/#{fileName}", "(#{userName}) (#{time}) #{message.text} \n", "utf8"

    # チャンネルリスト取得メソッド
    getChannelsList = (params, successHandler, errorHandler) ->
        slack.api "channels.list", params, (err, res) ->
            if res.ok
                # IDベースでマップを作る
                channelsMap = {}
                for channel in res.channels
                    channelsMap["#{channel.id}"] = channel

                successHandler channelsMap
            else
                errorHandler()

    # ユーザーリスト取得メソッド
    getUserList = (params, successHandler, errorHandler) ->
        slack.api "users.list", params, (err, res) ->
            if res.ok
                # IDベースでマップを作る
                membersMap = {}
                for member in res.members
                    membersMap["#{member.id}"] = member

                successHandler membersMap
            else
                errorHandler()

    # 履歴取得メソッド
    getHistory = (params, successHandler, errorHandler) ->
        messagesBuf = []

        # 再帰的に取得するメソッド
        getHistoryRecursively = (params, successHandler, errorHandler) ->
            slack.api "channels.history", params, (err, res) ->
                if res.ok
                    # 新しい方から配列に入っているので逆順で格納
                    messagesBuf = messagesBuf.concat res.messages.reverse()

                    if res.has_more
                        # 1回で取得しきれない場合は再帰的に取得
                        newParams = params
                        newParams.oldest = res.messages[0].ts

                        getHistoryRecursively newParams, successHandler, errorHandler
                    else
                        successHandler messagesBuf, params
                else
                    errorHandler()

        getHistoryRecursively params, successHandler, errorHandler

    # 今日の0時のタイムスタンプ
    getTodayTimeStamp = ->
        today = new Date()
        today.setHours(0)
        today.setMinutes(0)
        today.setSeconds(0)
        today.setMilliseconds(0)

        return today.getTime() / 1000

    # タイムスタンプから時間を取得
    getTime = (ts) ->
        date = new Date(ts*1000)
        hour = date.getHours()
        minutes = date.getMinutes()

        # 2桁で0埋めする
        if "#{hour}".length is 1
            hour = "0#{hour}"

        if "#{minutes}".length is 1
            minutes = "0#{minutes}"

        return "#{hour}:#{minutes}"


