#= This program starts a GUI, giving the user the options:
• Start a new game.
• Continue an old game.
• Replay a finished game.
• Quit

Starting a new game gives the following options:
• Start a game against the AI.
• Start a game against a human on the same computer.
• Join a game against a remote program.
• Host a game, using your AI as the player.
• Host a game, with a human as the player.
• Start a new game over email.

When starting a game, the following options should be available:

• Variant.
• Use time limits.
• Time limit.
• Time increment.
• Difficulty (only if against an AI)
• Japanese roulette mode. (flip the table on a loss, not on a resignation)
• Go first.
• Permit AI to cheat.
       The following difficulties should be available.
• Normal.
• Hard.
• Suicidal. (The AI plays the worst move possible.)
• Protracted death. (The AI protects the king, but otherwise plays worst moves possible.)
• Random AI.

Continuing a game should give the following options:
• Continue a local game.
• Take a turn in an email game.

=#

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





end






@printf("Filename: %s\nType: %s\nCheating: %s\nTimelimit: %s\nLimitadd: %s\n",filename,game,cheating=="T"?"on":"off", timelimit, limitadd)


  ARGS[1] = filename
  ARGS[2] = game #get first char of string
  ARGS[3] = cheating
  ARGS[4] = timelimit
  ARGS[5] = limitadd
include("start.jl")

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
<input type='button' value='run move.jl' onclick='movejl()' />
<div id='dvBHand'> </div>
<div id='dvTable'z> </div>
<div id='dvWHand'> </div>
<input type='button' value='exit' onclick='exit()' />
")

#☖☗
board = generateCurrentBoard()

function fillJSBoard(board::Board)
  boardArray = board.boardArray
   # println("current player", getCurrentPlayer(board))
   # printHand(board, BLACK)
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
end
println("Exit clicked")
