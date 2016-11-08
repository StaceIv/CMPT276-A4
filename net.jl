#=
net.jl <ip> <port> connects your AI to the
server given by the port and ip. Play the game to
completion
=#

#=
The accept() method retrieves a connection to the client that
is connecting on the server we just created, while the connect()
function connects to a server using the specified method.

"<wincode>:<authString>:<movenum>:<movetype>:<sourcex>:<sourcey>:<targetx>:<targety>:<option>:<cheating>:<targetx2>:<targety2>"

=#

#ip=parse(Int, ARGS[1])
#port = parse(Int, ARGS[2])
#clientside= connect(port)


function initializingGame()
  #initializing game wincode=game request (0)
  # "<wincode>: <gametype>: <legality>: <timelimit>: <limitadd>"
  println("Would you like to start a new game? (y/n)")
  createGame = chomp(readline(STDIN))
  payload="0:0:0:0:0"
  if createGame != "n"
    while true
        print("Enter name of the game: ")
        filename = chomp(readline(STDIN))
        print("Enter game type S(Shogi) or M(minishogi) or C(Chushogi): ")
        gameType = chomp(readline(STDIN))
        print("Type T or F to enable cheating. ")
        cheating =chomp( readline(STDIN))
        print("What is the timelimit for the game? ")
        timelimit =chomp( readline(STDIN))
        print("How much would you like to add to limitadd? ")
        limitadd =chomp( readline(STDIN))
        println("\nCONFIRM SETTINGS:")
        @printf("New Game:\nName: %s\nType: %s\nCheating: %s\nTimelimit: %s\nLimitadd: %s\n",filename,gameType,cheating, timelimit, limitadd)
        print("continue (y/n): ")
        cont = chomp(readline(STDIN))
        if cheating=='T'
          cheatingNet= 0
        else
          cheatingNet=1
        end
        payload=("0:$gameType:$cheatingNet:$timelimit:$limitadd")
        #start.jl <filename> <type> <cheating> <limit> <limit_add>
        ARGS[1]=filename  #throwing an error
        ARGS[2]=gameType
        ARGS[3]=cheating
        ARGS[4]=timelimit
        ARGS[5]=limitadd
        include(start.jl)

        if(cont!="n")
          break
        end
      end
    end
  #send(socket, payload)
end

#=
This payload is being sent from the server
"<wincode>:<authString>:<gameType>:<legality>:<timelimit>:<limitadd>”
wincode: either stating that you are player 1 or 2
=#
function acceptPayload(payload_S)
  payload=split(payload_S,":")
  authString=payload[2]
  if(payload[1]==9) #it is your turn
    #make a move wincode=2
    gameType=payload[3]
    if payload[4]==0
      cheating= F
    else
      cheating=T
    end
    timelimit= payload[5]
    limitadd= payload[6]
    #create game file
    include("move.jl")
    #get move from database
    #"<wincode>:<authString>:<movenum>:<movetype>:<sourcex>:<sourcey>:<targetx>:<targety>:<option>:<cheating>:<targetx2>:<targety2>"
    moveNum= #HOW TO FIND THIS???
    res = SQLite.query(db, "SELECT move_number FROM moves WHERE move_number = $moveNum;")
    number = get(res[1][1])
    res = SQLite.query(db, "SELECT move_type FROM moves WHERE move_number = $moveNum;")
    typeOfMove = get(res[1][1])
    if typeOfMove=="move"
      wincode=2
      res = SQLite.query(db, "SELECT sourcex FROM moves WHERE move_number = $moveNum;")
      sourcex = get(res[1][1])

      res = SQLite.query(db, "SELECT sourcey FROM moves WHERE move_number = $moveNum;")
      sourcey = get(res[1][1])

      res = SQLite.query(db, "SELECT targetx FROM moves WHERE move_number = $moveNum;")
      targetx = get(res[1][1])

      res = SQLite.query(db, "SELECT targety FROM moves WHERE move_number = $moveNum;")
      targety = get(res[1][1])

      res = SQLite.query(db, "SELECT option FROM moves WHERE move_number = $moveNum;")
      option== get(res[1][1])

      res = SQLite.query(db, "SELECT targetx2 FROM moves WHERE move_number = $moveNum;")
      if typeof(res[1][1])!= Nullable{Any}
        targetx2 = get(res[1][1])
      else
        targetx2=0
      end

      res = SQLite.query(db, "SELECT targety2 FROM moves WHERE move_number = $moveNum;")
      if typeof(res[1][1])!= Nullable{Any}
        targety2 = get(res[1][1])
      else
        targety2=0
      end

    elseif typeOfMove=="drop"
      wincode=2
      sourcex=0
      sourcey=0
      res = SQLite.query(db, "SELECT targetx FROM moves WHERE move_number = $moveNum;")
      targetx = get(res[1][1])

      res = SQLite.query(db, "SELECT targety FROM moves WHERE move_number = $moveNum;")
      targety = get(res[1][1])
      #option??
      targetx2=0
      targety2=0

    else
      #resign
      wincode=1
      sourcex=0
      sourcey=0
      targetx=0
      targety=0
      option=0
      targetx2=0
      targety2=0
      #must be able to disconnect here!!
      #close(clientside)
    end

      res = SQLite.query(db, "SELECT i_am_cheating FROM moves WHERE move_number = $moveNum;")
      if typeof(res[1][1])!= Nullable{Any}
        cheating = get(res[1][1])
      else
        cheating="Null"
      end
    payload=("$wincode:$authString:$number:$typeOfMove:$sourcex:$sourcey:$targetx:$targety:$option:$cheating:$targetx2:$targety2" )
    #return new playload to server
    #send(payload)
  elseif(payload[1]==8) #it is not your turn
    #wait until server sends wincode=9 and other player's data
    println("Please wait for the other player to finish their turn")
  end
end

#The game ends when a client sends a quit code or the server sends one of the termination codes.

#close(clientside)
initializingGame()
