module.exports = (robot) ->
  robot.hear /perochan/, (msg) ->
    msg.send msg.random [
        "誰ややつわ呼んだ",
        "なんの用や",
        "やんやんっ♡♡",
        "お前暇かよ"        
    ]
