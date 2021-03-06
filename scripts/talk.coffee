module.exports = (robot) ->
  robot.hear /ぺろちゃん/, (msg) ->
    msg.send "なんや"

  robot.hear /進捗どうですか/, (msg) ->
    msg.send "逆に進捗どうですかね？"

  robot.hear /おなかすいた/, (msg) ->
    msg.send "おなかすいてないし！"

  robot.router.get '/message/:message', (req, res) ->
    room = 'general'
    message = req.params.message
    envelope = room: room
    robot.send envelope, message
    res.end()

  robot.router.post '/minecraft/message', (req, res) ->
    room = '_minecraft'
    body = req.body
    message = body.message
    envelope = room: room
    robot.send envelope, message
    res.end()

  robot.router.post "/attendance", (req, res) ->
    body = req.body
    name = body.name
    state = body.state
    room = 'general'
    envelope = room: room

    if state is "在室"
      robot.send envelope, "#{name}さん がお部屋にログインしました٩(ˊᗜˋ*)و"
    else if state is "授業"
      robot.send envelope, "#{name}さん は授業に出かけたようです(´･ω･`)"
    else if state is "学内"
      robot.send envelope, "#{name}さん は学内を散歩してるみたいです(๑´ڡ`๑)"
    else if state is "休憩"
      robot.send envelope, "#{name}さん は休憩中です( ˘ω˘)"
    else 
      res.end "Thanks!\n"
      return
    res.end "Thanks!\n"

  robot.hear /.*(源本|げんもと|ゲンモト|genmoto).*/, (msg) ->
    msg.send "ゼミ長"
    keyword = encodeURIComponent "源本"
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


  robot.hear /.*(西内|にしうち|nishiuchi|nisiuchi|nishiuti|nishiuchi|nisiuchi|nisiuti).*/, (msg) ->
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

  robot.respond /perochan\s+選んで(\s+(.*))+$/i, (msg) ->
        list = msg.match[1].replace(/\s+/g," ");
        list = list.replace(/^\s+/, "").split(" ");
        random = Math.floor(Math.random() * list.length);
        msg.send "【#{list[random]}】 を選んでやったお！"

  robot.hear /perochan\s+(.*)とは$/i, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    url = "https://ja.wikipedia.org/w/api.php?action=opensearch&format=json&limit=1&redirects=resolve&search=#{keyword}"

    request = robot.http(url)
              .header('Accept', 'application/json')
              .get()
      
    request (err, res, body) ->
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
        #   msg.send "あっ，ちなみに画像はコレだよ！"
        #
        #   url = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=1&hl=ja&safe=off&q=#{keyword}"
        #
        #   robot.http(url)
        #     .get() (err, res, body) ->
        #
        #       data = null
        #       try
        #         data = JSON.parse(body)
        #       catch error
        #          msg.send "Ran into an error parsing JSON :("
        #          return
        #
        #       msg.send "#{data.responseData.results[0].unescapedUrl}"
        #       msg.send "じゃじゃーん！"
        #
