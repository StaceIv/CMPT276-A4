using Blink

w = Window()
sleep(3)
include("dependencies.jl")

load!(w,"GUI/js/jquery-1.10.1.min.js")
load!(w,"GUI/js/json3.min.js")
load!(w,"GUI/js/generateBoard.js")
#load!(w,"GUI/js/drag.js")
load!(w,"GUI/css/board.css")

sleep(3)

body!(w, "
<div id='dvBHand'> </div>
<div id='dvTable'z> </div>
<div id='dvWHand'> </div>
")

#☖☗
board = generateCurrentBoard()

function fillJSBoard(board::Board)
  boardArray = board.boardArray
   # println("current player", getCurrentPlayer(board))
   # printHand(board, BLACK)
    for j = BOARD_DIMENSIONS:-1:1
        for i= 1:BOARD_DIMENSIONS
        #add piece to item array in js
        @js w item.push($(boardArray[i,j]))
        end
        #add row to boardJS
        @js w boardJS.push(item.slice())
        @js w item.splice(0)
       # @printf("\n")
    end
  #  printHand(board, WHITE)
end

function fillJSPlayerHand(board::Board, player::AbstractString)
  handB = board.blackHand
  handW = board.whiteHand
  if player =="Black"
  for i= 1:length(handB)
    @js w blackHandJS.push($(handB[i]))
  end
elseif player == "White"
    for i= 1:length(handW)
     @js w whiteHandJS.push($(handW[i]))
  end
end
end

#@js w blackHandJS.push($(board.boardArray[1,1]));
#@js w blackHandJS.push($(board.boardArray[1,3]));
fillJSPlayerHand(board,"White")
fillJSPlayerHand(board,"Black")
fillJSBoard(board)
#opentools(w)



@js w generateTable();

#=
#MEMORY PROBLEMS HERE
#LOOP TO COMMUNICATE WITH WINDOW
status =""
while status != "exit"

status = @js w statusJS
if status == "generateTable"
  println("Generate Table clicked")
  status = @js w resetStatus()
end
if status == "movejl"
  println("movejl clicked")
  #include("move.jl") NOT WORKING
  status = @js w resetStatus()
end
end
=#
readline(STDIN)
println("exit clicked")
