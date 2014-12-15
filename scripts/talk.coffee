module.exports = (robot) ->
  robot.hear /ぺろちゃん/, (msg) ->
    msg.send "なんや"

  robot.hear /.*(西内|にしうち).*/, (msg) ->
    keyword = encodeURIComponent "ラーメン次郎"
    url = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=large&hl=ja&safe=off&q=#{keyword}"
    
    robot.http(url)
      .get() (err, res, body) ->

        data = null
        try
          data = JSON.parse(body)
        catch error
          msg.send "Ran into an error parsing JSON :("
          return

        random = Math.floor(Math.random() * 8);
        msg.send "#{data.responseData.results[random].unescapedUrl}"

  robot.respond /perochan\s+(.*)とは$/i, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    url = "http://ja.wikipedia.org/w/api.php?action=opensearch&format=json&limit=1&redirects=resolve&search=#{keyword}"
    msg.send url

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
          return
        else
          msg.send "#{decodeURIComponent(data[3])}"
          msg.send "これでまた１つ賢くなれるね＾＾"
          msg.send "あっ，ちなみに画像はコレだよ！"

          url = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=1&hl=ja&safe=off&q=#{keyword}"

          robot.http(url)
            .get() (err, res, body) ->

              data = null
              try
                data = JSON.parse(body)
              catch error
                 msg.send "Ran into an error parsing JSON :("
                 return

              msg.send "#{data.responseData.results[0].unescapedUrl}"
              msg.send "じゃじゃーん！"
