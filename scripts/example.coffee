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

  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  
  default_lunch_options = ['路沖牛肉麵:cow:', 'Joyfull:shit:', 'すき家:sukiya:','創義麵 :spaghetti:',
  '泰式:國際化的夏天-泰:', 'ATT:department_store:', '美麗華:ferris_wheel:', '賢記熱炒:fireball:', '德記麻油雞麵線:chicken:', '裕濠小館:meat_on_bone:', '麥當勞:logo_macdonald:',
  '佳佳牛排館:cut_of_meat:', '林文必涼麵:ramen:', '亞米食坊:mincedporkrice:', '八方雲集:鍋貼:', '阿國仔傳統切仔麵:knife:', 'Meladle 日式蛋包飯:hatching_chick:',
  '滿座小火鍋:stew:']
  lunch_options = default_lunch_options.slice()

  getOptions = (robot) -> (
    if(robot.brain.get('lunch_options')?)
      robot.brain.get('lunch_options')
    else 
      robot.brain.set 'lunch_options', default_lunch_options
      default_lunch_options
  )
  
  # randomly pick an option
  robot.hear /吃啥|午餐|lunch/i, (res) ->
    options = getOptions(robot)
    res.send "今晚，我想來點...  #{res.random options}"

  # list all options
  robot.hear /^l[s|a|l]$/i, (res) ->
    options = getOptions(robot)
    list = []
    i = 0
    for l in options
      list.push "#{i}. #{l}"
      i++
    res.send list.join('\r\n')
  
  # add an option
  robot.respond /add (.*)/i, (res) ->
    option = res.match[1]
    if option?
      lunch_options.push option
      robot.brain.set 'lunch_options', lunch_options
    res.reply "option #{option} added!"

  # remove option by index
  robot.respond /remove (\d+)/i, (res) ->
    if(!(getOptions(robot).length > 0))
      res.reply "list is empty!"
      return
    index = res.match[1]
    if index?
     try
        lunch_options.splice(index, 1)
        robot.brain.set 'lunch_options', lunch_options
        res.reply "index `#{index}` removed!"
      catch error
        res.reply "index `#{index}` does not exist!"
    else
      res.send "index not found!"

  # remove option by option name
  robot.respond /remove (\D+)/i, (res) ->
    option = res.match[1]
    if option?
      lunch_options = lunch_options.filter (word) -> word isnt option
      robot.brain.set 'lunch_options', lunch_options
    res.reply "option #{option} removed!"

  # reset options
  robot.respond /reset/i, (res) ->
    lunch_options = default_lunch_options.slice()
    robot.brain.set 'lunch_options', default_lunch_options
    res.reply "option reset!"
  
  helpCommand = """
                - `lunch` | `午餐` | `吃啥` : randomly suggest a lunch place.
                - `ls` , `la` , `ll` : list all lunch options.
                - `@Kevin_the_bot add {Option}` : add a new lunch option.
                - `@Kevin_the_bot remove {index}` : remove the option of index.
                - `@Kevin_the_bot remove {name}` : remove the option by it's name.
                - `@Kevin_the_bot reset` : reset the option list to default.
                - `help` : Kevin will help you.
                """

  # help command 
  robot.hear /^help$/i, (res) ->
    res.send helpCommand

  # welcome message
  robot.enter (res) ->
    res.send helpCommand
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
