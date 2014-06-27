# Description:
#   Outputs a list of Hacker News articles.
#
# Dependencies:
#   None
#
# Configuration:
#   None
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
http = require('http')

sanitize (string) ->
  string.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')

linkTo(url, text) ->
  "<a href=\"#{url}\">#{sanitize(text)}</a>"

respondWithHN = (message) ->
  message.http('http://api.ihackernews.com/page').get() (error, res, body) ->
    json  = JSON.parse(body)
    items = json.items.map (item) ->
      linkTo(item.url, item.title)

    items.forEach (item, index) ->
      http.request(
        host: "api.hipchat.com"
        path: "/v1/rooms/message?auth_token=#{env.HIPCHAT_TOKEN}&room_id=#{env.GITLAB_HIPCHAT_ROOMS}&from=HN-#{index}&message_format=html&format=json&message=#{item}"
      ).end()

module.exports = (robot)->
  robot.respond /hacker(\s?news)?/i, respondWithHN
  robot.respond /hn( me)?/i, respondWithHN
