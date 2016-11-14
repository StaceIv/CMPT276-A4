using Blink

ARGS =fill("",6) #create ARGS array to pass parameters to the other julia files.
filename =""
game =""
gameTypeN=""
cheating =""
timelimit=""
limitadd=""
gameDifficulty = ""
filp = ""

startWindow = Window()
sleep(3)
load!(startWindow,"GUI/js/jquery-1.10.1.min.js")
load!(startWindow,"GUI/js/json3.min.js")
load!(startWindow,"GUI/js/generateBoard.js")
load!(startWindow,"GUI/css/startWindow.css")

sleep(3)

body!(startWindow, "
    
<h1>Welcome to SHOGI</h1>

<div class='newGame'>
  <input type='button' onclick='startNewGame()' value='Start new game'>
</div>
<div class='contGame'>
  <input type='text' id='contText' placeholder='Enter file name'/>
  <input type='button' onclick='contGame()' value='Continue game'>
</div>
<div class='replayGame'>
  <input type='text' id='replayText' placeholder='Enter file name'/>
  <input type='button' onclick='replayGame()' value='Replay game'>
</div>
<div class='quitGame'>
  <input type='button' onclick='exit()' value='Quit'>
</div>


")

status =""
while status != "exit"
    sleep(0.01)
    status = @js startWindow statusJS
    if status == "newGame"
        println("new Game clicked")
        break
        #status = @js startWindow resetStatus()    
    end
    if status == "contGame"
        println("continue game clicked")
        filename = @js startWindow contGame()
        break
        #status = @js startWindow resetStatus()
    end

    if status == "replayGame"
        println("replay game clicked")
        filename = @js startWindow replayGame()
        break
        #status = @js startWindow resetStatus()
    end
    

end


close(startWindow)


if status == "newGame"
        newGameWindow = Window()
        
        sleep(3)
        load!(newGameWindow,"GUI/js/jquery-1.10.1.min.js")
        load!(newGameWindow,"GUI/js/json3.min.js")
        load!(newGameWindow,"GUI/js/generateBoard.js")
        #load!(newGameWindow,"GUI/css/newGameWindow.css")
        
        sleep(3)
        
        body!(newGameWindow, "
            
                <h1>Create New Game</h1>
                
                <div class='container'>
                         <input type='button' onclick='remoteGame()' value='Remote'>
                         <input type='button' onclick='localP()' value='Local(Player)'>
                         <input type='button' onclick='localAI()' value='Local(AI)'>
                         <input type='button' onclick='HostP()' value='Host(Player)'>
                         <input type='button' onclick='HostAI()' value='Host(AI)'>
                </div>

                <div class='nameGame'>
                  <label for='fileText'>File Name:</label>
                  <input type='text' id='fileText' placeholder='Enter file name'/>
                </div>

                <div class='typeGame'>
                    <label for='gameType'>Game Type:</label>
                  <select class='selectbox' id='gameType'>
                    <option>Mini</option>
                    <option selected='selected'>Shogi</option>
                    <option>Chu</option>
                    <option>Tenjiku</option>
                  </select>
                </div>    

                <div class='cheatGame'>
                    <label for='cheatcheckbox'>Cheating:</label>
                    <input type='checkbox' id='cheatcheckbox'>
                </div>


                <div class='timeLimGame'>
                  <label for='timeLimit'>Time Limit:</label>
                  <input type='number' min='0' id='timeLimit' placeholder='Optional'/>
                </div>    

                <div class='timeIncGame'>
                  <label for='timeInc'>Time Increment:</label>
                  <input type='number' min='0' id='timeInc' placeholder='Optional'/>
                </div>    

                <div class='difficultyGame'>
                    <label for='gameType'>Game Difficulty:</label>
                  <select class='selectbox' id='gameDifficulty'>
                    <option selected='selected'>Normal</option>
                    <option>Hard</option>
                    <option>Suicidal</option>
                    <option>Protracted death</option>
                    <option>Random AI</option>
                  </select>
                </div>    

                <div class='flipGame'>
                    <label for='flipcheckbox'>Japanese roulette mode:</label>
                    <input type='checkbox' id='flipcheckbox'>
                </div>

                <H1>STUFF FOR SERVER GO HERE</H1>


                <div class='container'>
                  <input type='button' onclick='getValues()' value='Continue'>
                </div>
        
        
        ")
        
        status =""
        while status != "exit"
            sleep(0.01)
            status = @js newGameWindow statusJS
        
            if status == "continue"
                println("continue game clicked")
                @js newGameWindow getValues()
                filename = @js newGameWindow filenameJS
                game =@js newGameWindow gameTypeJS
                cheating =@js newGameWindow cheatingJS
                timelimit=@js newGameWindow timelimitJS
                limitadd=@js newGameWindow limitaddJS
                gameDifficulty = @js newGameWindow difficultyJS
                flip = @js newGameWindow flipJS

                break
                #status = @js newGameWindow resetStatus()
            end
            
        
        end
        
        
        close(newGameWindow)
        @printf("Filename: %s\nType: %s\nCheating: %s\nTimelimit: %s\nLimitadd: %s\n",filename,game,cheating=="T"?"on":"off", timelimit, limitadd)

  ARGS[1] = filename
  ARGS[2] = game #get first char of string
  ARGS[3] = cheating
  ARGS[4] = timelimit
  ARGS[5] = limitadd
  include("start.jl")




end

ARGS[1] = filename






#DISPLAYING BOARD
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
<input type='button' value='Generate current board' onclick='generateTable()' />
<input type='button' value='Make move' onclick='makeMove()' />
<input type='button' value='run move.jl' onclick='movejl()' />
<div id='currentPlayer'></div>
<div id='dvBHand'> </div>
<div id='dvTable'> </div>
<div id='dvWHand'> </div>
<input type='button' value='exit' onclick='exit()' />
")

#☖☗
board = generateCurrentBoard()

function fillJSBoard(board::Board)
  boardArray = board.boardArray
   # println("current player", getCurrentPlayer(board))
   # printHand(board, BLACK)
   @js w getPlayer($(getCurrentPlayer(board)))
    for j = BOARD_DIMENSIONS:-1:1
        for i= 1:BOARD_DIMENSIONS
        # add piece to item array in js
        @js w item.push($(boardArray[i,j]))
        end
        # add row to boardJS
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

tools(w)

@js w generateTable();


#LOOP TO COMMUNICATE WITH WINDOW

status =""
while status != "exit"
sleep(0.01)
status = @js w statusJS
if status == "generateTable"
  println("Generate Table clicked")
  status = @js w resetStatus()
end
if status == "movejl"
  println("movejl clicked")
  include("move.jl")
  status = @js w resetStatus()
end
if status == "makeMove"
  println("make move clicked")
  arr = @js w movesArrayJS
  
  println(arr)
  if length(arr) == 2
  ARGS[2] = split(arr[1],",")[1]
  ARGS[3] = split(arr[1],",")[2]
  ARGS[4] = split(arr[2],",")[1]
  ARGS[5] = split(arr[2],",")[2]
  ARGS[6] = "F" #CHANGE THIS!!!!!!!!!!!!!!!!
  elseif length(arr) == 3
  ARGS[2] = split(arr[1],",")[1]
  ARGS[3] = split(arr[1],",")[2]
  ARGS[4] = split(arr[2],",")[1]
  ARGS[5] = split(arr[2],",")[2]
  ARGS[6] = "F" #CHANGE THIS!!!!!!!!!!!!!!!!
  ARGS[7] = split(arr[3],",")[1]
  ARGS[8] = split(arr[3],",")[2]
  elseif length(arr) == 4
  ARGS[2] = split(arr[1],",")[1]
  ARGS[3] = split(arr[1],",")[2]
  ARGS[4] = split(arr[2],",")[1]
  ARGS[5] = split(arr[2],",")[2]
  ARGS[6] = "F" #CHANGE THIS!!!!!!!!!!!!!!!!
  ARGS[7] = split(arr[3],",")[1]
  ARGS[8] = split(arr[3],",")[2]
  ARGS[9] = split(arr[4],",")[1]
  ARGS[10]= split(arr[4],",")[2]
  else
      @js w alert("INVALID MOVE. REJECTED!")
      status = @js w resetStatus()
      continue
  end
  println(ARGS)
  include("move_user_move.jl")

  board = generateCurrentBoard()

  @js w deleteTables()
  fillJSBoard(board)
  fillJSPlayerHand(board,"White")
  fillJSPlayerHand(board,"Black")


  @js w movesArrayJS.splice(0)
  status = @js w resetStatus()
  @js w generateTable()

end

end
println("Exit clicked")

