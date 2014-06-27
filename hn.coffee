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
respondWithHN = (message) ->
  message.http('http://api.ihackernews.com/page').get() (error, res, body) ->
    json  = JSON.parse(body)
    items = json.items.map (item) ->
      "#{item.title} - #{item.url}"

    message.send items.join("\n")

module.exports = (robot)->
  robot.respond /hacker(\s?news)?/i, respondWithHN
  robot.respond /hn( me)?/i, respondWithHN
