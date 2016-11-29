#=
move_user_move.jl <filename> <xsource>
<ysource> <xtarget> <ytarget> <promote> <xtarget2>
<ytarget2>
=#

include("dependencies.jl")

#Initializing database
using SQLite

function usage(message)
  println("move_user_move.jl <filename> <xsource> <ysource> <xtarget> <ytarget> <promote> <xtarget2> <ytarget2>")
  println(message)
  exit(1)
end

#= This populates the Database =#
function populateDBMove()
  db=SQLite.DB(ARGS[1])
  if isdefined(ARGS, 7) && isdefined(ARGS, 8)
    println("THERE EXIST X2 Y2.")
    ######################ADD TARGETX3 TARGETY3 (if they exist?)

      if isdefined(ARGS, 9)
        println("THERE EXIST X3 Y3.")
        if ARGS[6] == "T"
          promotion = "\'!\'"
          SQLite.query(db, "INSERT INTO moves (move_number, move_type, sourcex, sourcey, targetx, targety, option, targetx2, targety2, targetx3, targety3) VALUES ($(numberOfMove()+1), 'move', $(ARGS[2]), $(ARGS[3]), $(ARGS[4]), $(ARGS[5]), $promotion, $(ARGS[7]), $(ARGS[8]), $(ARGS[9]), $(ARGS[10]))")
        elseif ARGS[6] == "F"
          SQLite.query(db, "INSERT INTO moves (move_number, move_type, sourcex, sourcey, targetx, targety, targetx2, targety2, targetx3, targety3) VALUES ($(numberOfMove()+1), 'move', $(ARGS[2]), $(ARGS[3]), $(ARGS[4]), $(ARGS[5]), $(ARGS[7]), $(ARGS[8]), $(ARGS[9]), $(ARGS[10]))")
        end
      elseif !isdefined(ARGS, 9)
        println("THERE ARE NO X3 Y3")
        if ARGS[6] == "T"
          promotion = "\'!\'"
          SQLite.query(db, "INSERT INTO moves (move_number, move_type, sourcex, sourcey, targetx, targety, option, targetx2, targety2) VALUES ($(numberOfMove()+1), 'move', $(ARGS[2]), $(ARGS[3]), $(ARGS[4]), $(ARGS[5]), $promotion, $(ARGS[7]), $(ARGS[8]))")
        elseif ARGS[6] == "F"
          SQLite.query(db, "INSERT INTO moves (move_number, move_type, sourcex, sourcey, targetx, targety, targetx2, targety2) VALUES ($(numberOfMove()+1), 'move', $(ARGS[2]), $(ARGS[3]), $(ARGS[4]), $(ARGS[5]), $(ARGS[7]), $(ARGS[8]))")
        end
      end

  elseif !isdefined(ARGS, 7)
    println("THERE ARE NO X2 Y2")
    if ARGS[6] == "T"
      promotion = "\'!\'"
      SQLite.query(db, "INSERT INTO moves (move_number, move_type, sourcex, sourcey, targetx, targety, option) VALUES ($(numberOfMove()+1), 'move', $(ARGS[2]), $(ARGS[3]), $(ARGS[4]), $(ARGS[5]), $promotion)")
    elseif ARGS[6] == "F"
      SQLite.query(db, "INSERT INTO moves (move_number, move_type, sourcex, sourcey, targetx, targety) VALUES ($(numberOfMove()+1), 'move', $(ARGS[2]), $(ARGS[3]), $(ARGS[4]), $(ARGS[5]))")
    end
  end

    #println(SQLite.query(db,"SELECT * FROM moves"))
end

  #Returns the number of Moves in the game
  #which is just the number of lines in the moves table
function numberOfMove()
  db = SQLite.DB(ARGS[1])
  res = SQLite.query(db, "SELECT COUNT(*) FROM moves;")
  x = get(res[1][1])
  return x
end

#Checks for filename
if !isdefined(ARGS, 1)
  usage("File Name is mandatory")
end

#Checks for xsource
if !isdefined(ARGS, 2)
  usage("Initial x-position is mandatory")
end

#Checks for ysource
if !isdefined(ARGS, 3)
  usage("Initial y-position is mandatory")
end

#Checks for xtarget
if !isdefined(ARGS, 4)
  usage("Final x-position is mandatory")
end

#Checks for ytarget
if !isdefined(ARGS, 5)
  usage("Final y-position is mandatory")
end

#checks if xtarget2 exists but ytarget2 does not, and vice versa
if isdefined(ARGS, 7) && !isdefined(ARGS, 8)
  usage("Corresponding ")
end

#Checks if Promoted
if !isdefined(ARGS, 6)
  usage("Must say whether or not the piece is promoted.")
end

populateDBMove()

println(numberOfMove())
#= unit test code - to be removed from the production code =#
#= print the content of the moves table =#
printMoves()
