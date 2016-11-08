
#println(ARGS[1])
global const gameType = getType(ARGS[1])
if gameType == "standard"
  global const BOARD_DIMENSIONS = 9 #BOARD_DIMENSIONS
  global const PROMOTION_TOP = 7
  global const PROMOTION_BOTTOM = 3
elseif gameType == "minishogi"
  global const BOARD_DIMENSIONS = 5
  global const PROMOTION_TOP = 5
  global const PROMOTION_BOTTOM = 1
elseif gameType == "chu"
  global const BOARD_DIMENSIONS = 12
  global const PROMOTION_TOP = 9
  global const PROMOTION_BOTTOM = 4
else
  assert(false)
end

global const WHITE = "White"
global const BLACK = "Black"

#Types of moves
global const MOVETYPE_MOVEMENT = "move"
global const MOVETYPE_DROP = "drop"
global const MOVETYPE_RESIGN = "resign"

#Options in moves
#todo #global const MOVEOPTION_

global const GAMETYPE_MINI = "minishogi"
global const GAMETYPE_STANDARD = "standard"
global const GAMETYPE_CHU = "chu"
