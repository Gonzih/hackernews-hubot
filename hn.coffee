# Description:
#   Outputs a list of Hacker News articles.
#
# Dependencies:
#   None
#
# Configuration:
#   HN_HIPCHAT_COLOR - green by default
#   HIPCHAT_TOKEN - v1 api token
#   HN_HIPCHAT_ROOM - target room
#
# Commands:
#   hubot nh me       - Returns front page of HN
#   hubot nh          - Returns front page of HN
#   hubot hackernews  - Returns front page of HN
#   hubot hacker news - Returns front page of HN
#   hubot hacker      - Returns front page of HN
#
# Author:
#   Max Gonzih
#
#
sanitize = (string) ->
  string.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')

linkTo = (url, text, points, comments) ->
  "<a href=\"#{url}\">#{sanitize(text)} - [#{points} (#{comments})]</a>"

respondWithHN = (message) ->
  message.http('http://api.ihackernews.com/page').get() (error, res, body) ->
    try
      json  = JSON.parse(body)
      items = json.items.map (item) ->
        linkTo(item.url, item.title, item.points, item.commentCount)

      env = process.env
      color = env.HN_HIPCHAT_COLOR || 'green'
      url = "http://api.hipchat.com/v1/rooms/message?auth_token=#{env.HIPCHAT_TOKEN}&room_id=#{env.HN_HIPCHAT_ROOM}&color=#{color}&from=HackerNews&message_format=html&format=json&message=#{items.join("<br />")}"
      message.http(url)
        .get() (error, res, body) ->
          console.log(body)
    catch e
      console.log(e)

module.exports = (robot)->
  robot.respond /hacker(\s?news)?/i, respondWithHN
  robot.respond /hn( me)?/i, respondWithHN
