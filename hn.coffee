# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot nh me - Returns front page
#
# Author:
#   Max Gonzih
#
#
respondWithHN = (message) ->
  message.http('http://api.ihackernews.com/page').get() (error, res, body) ->
    json = JSON.parse(body)
    items = json.items.map (item) ->
      "#{item.title} - #{item.points} (#{item.commentCount})\n  #{item.url}\n"

    message.send items.join("\n")

module.exports = (robot)->
  robot.respond /hacker(\s?news)?/i, respondWithHN
  robot.respond /hn( me)?/i, respondWithHN
