module.exports = (robot) ->
  robot.hear /ぺろちゃん/, (msg) ->
    msg.send "なんや"

  robot.respond /perochan (.*)とは$/i, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    url = "http://ja.wikipedia.org/w/api.php?action=opensearch&format=json&limit=1&search=#{keyword}"

    robot.http(url)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->

        data = null
        try
          data = JSON.parse(body)
        catch error
          msg.send "Ran into an error parsing JSON :("
          return

        if data[3].length is 0
          msg.send "そのキーワードじゃ見つからなかったよ！ちゃんとしたやつ指定しろや"
        else
          msg.send "#{data[3]}"
          msg.send "これでまた１つ賢くなれるね＾＾"
