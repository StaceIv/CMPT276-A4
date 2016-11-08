#=
Legal_moves helper function
=#

#Movement helpers
function moveForwards(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  if piece.color == WHITE
    moveN(legal, board, piece, sourcex, sourcey)
  elseif piece.color == BLACK
    moveS(legal, board, piece, sourcex, sourcey)
  else
    assert(false)
  end
end

function moveBackwards(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  if piece.color == WHITE
    return moveS(legal, board, piece, sourcex, sourcey)
  elseif piece.color == BLACK
    return moveN(legal, board, piece, sourcex, sourcey)
  else
    assert(false)
  end
end

function moveN(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex, sourcey+1)
end

function moveNE(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+1, sourcey+1)
end

function moveE(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+1, sourcey)
end

function moveSE(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+1, sourcey-1)
end

function moveS(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex, sourcey-1)
end

function moveSW(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-1, sourcey-1)
end

function moveW(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-1, sourcey)
end

function moveNW(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-1, sourcey+1)
end


function chainMovement(legal::Array{Move}, board::Board, piece::Piece, movement::Function, sourcex::Int, sourcey::Int)
  newLegal = Array{Move}(0)

  movement(newLegal, board, piece, sourcex, sourcey)
  if length(newLegal) != 0
    append!(legal, newLegal)
  end
  while length(newLegal) != 0  && isNullPiece(getPiece(board, newLegal[end].targetx, newLegal[end].targety)) #stop when the movement hits an obstruction, or when it moves onto an enemy
    newX::Int = newLegal[end].targetx
    newY::Int = newLegal[end].targety

    newLegal = Array{Move}(0)
    movement(newLegal, board, piece, newX, newY)
    if length(newLegal) != 0
      newLegal[1].sourcex = sourcex
      newLegal[1].sourcey = sourcey #CHANGE THE sourcex AND sourcey TO CORRECT START LOCATION
      append!(legal, newLegal)
    end
  end
end

#for Chu Shogi
function doubleMove(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int,  move1::Function, move2::Function)
  firstLegal = Array{Move}(0)
  secondLegal = Array{Move}(0)
  move1(firstLegal, board, piece, sourcex, sourcey)
  if length(firstLegal) != 0
    move2(secondLegal, board, piece, firstLegal[end].targetx, firstLegal[end].targety)
    #= firstLegal and secondLegal will either have 0, 1 or 2 elements; 0 if there is no legal space to move in, 1 if there is, and 2 if that space is
    a promotion zone (one for moving and promoting, and one for just moving. The move with a promote will be the 2nd element) =#

    if length(secondLegal) != 0 #first and second moves are legal
      lastMove = secondLegal[end]
      newMove = initMoveDoubleMovement(sourcex, sourcey, lastMove.sourcex, lastMove.sourcey, nothing, lastMove.targetx, lastMove.targety) #legal to move in
      push!(legal, newMove)
      #Pieces that double move can't promote - Lion, Eagle, Falcon
    end
  end
end

#covers movement entrance, not drops
function tryToEnter(legal::Array{Move}, board::Board, piece::Piece, sourcex::Int, sourcey::Int, targetx::Int, targety::Int)
  if targetx >= 1 && targety >= 1 && targetx <= BOARD_DIMENSIONS && targety <= BOARD_DIMENSIONS #if target in bounds
    occupyingPiece = getPiece(board, targetx, targety)

    if isNullPiece(occupyingPiece) || occupyingPiece.color != piece.color #target square is empty, or enemy colored piece
      newMove = initMoveMovement(sourcex, sourcey, targetx, targety, nothing)
      push!(legal, newMove) #legal to just move in

      if (piece.color == WHITE && targety >= PROMOTION_TOP) || (piece.color == BLACK && targety <= PROMOTION_BOTTOM)#if target square is in the promotionzone for the piece moving in
        newMove = initMoveMovement(sourcex, sourcey, targetx, targety, "!")
        push!(legal, newMove) #legal to move in and promote
      end
    end
  end
end


#Goes through all squares on the board and compiles the legal moves possible from that space. Includes resign as the last item
function allLegalMoves(board::Board)
  legal = Array{Move}(0)
  #TODO, this should use allLegalMovementMoves
  for x in 1:BOARD_DIMENSIONS
    for y in 1:BOARD_DIMENSIONS
      append!(legal, legalMovesForSpace(board, x, y))
    end
  end
  currentHand = handForPlayer(board, getCurrentPlayer(board))
  #chu shogi doesnt have drops
  if gameType != "chu"
    for piece in currentHand
      legalDrops(legal, board, piece)
    end
  end

  push!(legal, initMoveResign() )

  return legal
end


function allLegalMovementMoves(board::Board)
  legal = Array{Move}(0)
  for x in 1:BOARD_DIMENSIONS
    for y in 1:BOARD_DIMENSIONS
      append!(legal, legalMovesForSpace(board, x, y))
    end
  end
  return legal
end


#Legal drops for a single piece
function legalDrops(legal::Array{Move}, board::Board, piece::Piece)
  for x in 1:BOARD_DIMENSIONS
    for y in 1:BOARD_DIMENSIONS
      if isNullPiece(getPiece(board, x, y)) #target square is empty
        newMove = initMoveDrop(x, y, piece)
        push!(legal, newMove)  #legal to drop the piece there
      end
    end
  end
end


#Returns a list of legal moves that don't put in check. Includes resign as the last item.
function allLegalNotStupidMoves(board::Board)
  allMoves = allLegalMoves(board)
  notStupidMoves = Array{Move}(0)

  tempKingPiece = Piece( getCurrentPlayer(board), King )
  defaultKingX, defaultKingY = findPiece(board, tempKingPiece)

  for i in 1:length(allMoves)-1 #all but resign
    if allMoves[i].move_type == MOVETYPE_MOVEMENT
      ####Check that you aren't moving into check, you stupid ai
      #Make a simulation of the board after moving
      tempBoard = deepcopy(board)
      updateBoard(tempBoard, allMoves[i])

      #find the king's coordinates
      if getPiece(tempBoard, allMoves[i].sourcex, allMoves[i].sourcey).name == King #If the king moved, get its new location
        kingX, kingY = findPiece(tempBoard, tempKingPiece)
      else #King hasn't moved, use default location.
        kingX = defaultKingX
        kingY = defaultKingY
      end
      if !isPieceInCheck(tempBoard, kingX, kingY)
        push!(notStupidMoves, allMoves[i])
      end

    else #It's not a move so it can't be bad
      push!(notStupidMoves, allMoves[i])
    end
  end

  push!(notStupidMoves, allMoves[end]) #add resign too. Gotta have that even when its in check.

  return notStupidMoves
end


function popResignIfOtherOptions(movesList)
  if length(movesList) > 1
    pop!(movesList)
  end
end





#=
  Loops through all figures and calls the function which passes
  figureType, current Location, and a boolean which is set to true if
  it is our turn to make a move or false if it is the oppontents turn
  return set of legal moves for that figure
=#
###Legal moves
function legalMovesForSpace(board::Board, sourcex::Int, sourcey::Int)
  piece = getPiece(board, sourcex, sourcey)
  if piece.color == getCurrentPlayer(board)
    if gameType == "standard" || gameType == "minishogi"
      legalMovesStandard(board, piece, sourcex, sourcey)
    elseif gameType == "chu"
      legalMovesChu(board, piece, sourcex, sourcey)
    end
  else
    return []
  end
end

function  legalMovesStandard(board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  if piece.name == King                             #King
    return legalKing(board, sourcex, sourcey)
  elseif piece.name == Pawn                         #Pawn
    return legalPawn(board, sourcex, sourcey)
  elseif piece.name == PPawn                        #Promoted Pawn
    return legalGold(board, sourcex, sourcey)
  elseif piece.name == GoldGeneral                  #Gold General
    return legalGold(board, sourcex, sourcey)
  elseif piece.name == SilverGeneral                #Silver General
    return legalSilver(board, sourcex, sourcey)
  elseif piece.name == PSilverGeneral               #Promoted Silver General
    return legalGold(board, sourcex, sourcey)
  elseif piece.name == Bishop                       #Bishop
    return legalBishop(board, sourcex, sourcey)
  elseif piece.name == PBishop                      #Promoted Bishop
    return legalPBishop(board, sourcex, sourcey)
  elseif piece.name == Rook                         #Rook
    return legalRook(board, sourcex, sourcey)
  elseif piece.name == PRook                        #Promoted Rook
    return legalPRook(board, sourcex, sourcey)
  elseif piece.name == Lance                        #Lance
    return legalLance(board, sourcex, sourcey)
  elseif piece.name == PLance                       #Promoted Lance
    return legalGold(board, sourcex, sourcey)
  elseif piece.name == Knight                       #Knight
    return legalKnight(board, sourcex, sourcey)
  elseif piece.name == PKnight                      #Promoted Knight
    return legalGold(board, sourcex, sourcey)
  else
    #tracePrint(piece.name)
    assert( isNullPiece(piece) )
  end
end

function  legalMovesChu(board::Board, piece::Piece, sourcex::Int, sourcey::Int)
  if piece.name == King                             #King
    return legalKing(board, sourcex, sourcey)
  elseif piece.name == Pawn                         #Pawn
    return legalPawn(board, sourcex, sourcey)
  elseif piece.name == PPawn                        #Promoted Pawn
    return legalGold(board, sourcex, sourcey)
  elseif piece.name == GoldGeneral                  #Gold General
    return legalGold(board, sourcex, sourcey)
  elseif piece.name == SilverGeneral                #Silver General
    return legalSilver(board, sourcex, sourcey)
  elseif piece.name == PSilverGeneral               #Promoted Silver General
    return legalVerticalMover(board, sourcex, sourcey)
  elseif piece.name == Bishop                       #Bishop
    return legalBishop(board, sourcex, sourcey)
  elseif piece.name == PBishop                      #Promoted Bishop
    return legalPBishop(board, sourcex, sourcey)
  elseif piece.name == Rook                         #Rook
    return legalRook(board, sourcex, sourcey)
  elseif piece.name == PRook                        #Promoted Rook
    return legalPRook(board, sourcex, sourcey)
  elseif piece.name == Lance                        #Lance
    return legalLance(board, sourcex, sourcey)
  elseif piece.name == PLance                       #Promoted Lance
    return legalWhiteHorse(board, sourcex, sourcey)
  elseif piece.name == ReverseChariot               #Reverse Chariot
    return legalChariot(board, sourcex, sourcey)
  elseif piece.name == PReverseChariot              #Promoted Reverse Chariot
    return legalWhale(board, sourcex, sourcey)
  elseif piece.name == CopperGeneral                #Copper General
    return legalCopper(board, sourcex, sourcey)
  elseif piece.name == PCopperGeneral               #Promoted Copper General
    return legalSideMover(board, sourcex, sourcey)
  elseif piece.name == DragonKing                   #Dragon King
    return legalPRook(board, sourcex, sourcey)
  elseif piece.name == PDragonKing                  #Promoted Dragon King
    return legalEagle(board, sourcex, sourcey)
  elseif piece.name == DrunkenElephant              #Drunken Elephant
    return legalElephant(board, sourcex, sourcey)
  elseif piece.name == PDrunkenElephant             #Promoted Drunken Elephant
    return legalKing(board, sourcex, sourcey)
  elseif piece.name == FerociousLeopard             #Ferocious Leopard
    return legalLeopard(board, sourcex, sourcey)
  elseif piece.name == PFerociousLeopard            #Promoted Ferocious Leopard
    return legalBishop(board, sourcex, sourcey)
  elseif piece.name == DragonHorse                  #Dragon Horse
    return legalPBishop(board,sourcex, sourcey)
  elseif piece.name == PDragonHorse                 #Promoted Dragon Horse
    return legalFalcon(board, sourcex, sourcey)
  elseif piece.name == Lion                         #Lion
    return legalLion(board, sourcex, sourcey)
  elseif piece.name == SideMover                    #Side Mover
    return legalSideMover(board, sourcex, sourcey)
  elseif piece.name == PSideMover                   #Promoted Side Mover
    return legalBoar(board, sourcex, sourcey)
  elseif piece.name == Kirin                        #Kirin
    return legalKirin(board, sourcex, sourcey)
  elseif piece.name == PKirin                       #Promoted Kirin
    return legalLion(board, sourcex, sourcey)
  elseif piece.name == GoBetween                    #Go-Between
    return legalGoBetween(board, sourcex, sourcey)
  elseif piece.name == PGoBetween                   #Promoted Go-Between
    return legalElephant(board, sourcex, sourcey)
  elseif piece.name == BlindTiger                   #Blind Tiger
    return legalTiger(board, sourcex, sourcey)
  elseif piece.name == PBlindTiger                  #Promoted Blind Tiger
    return legalStag(board, sourcex, sourcey)
  elseif piece.name == Queen                        #Queen
    return legalQueen(board, sourcex, sourcey)
  elseif piece.name == VerticalMover                #Vertical Mover
    return legalVerticalMover(board, sourcex, sourcey)
  elseif piece.name == PVerticalMover               #Promoted Vertical Mover
    return legalOx(board, sourcex, sourcey)
  elseif piece.name == Phoenix                      #Phoenix
    return legalPhoenix(board, sourcex, sourcey)
  elseif piece.name == PPhoenix                     #Promoted Phoenix
    return legalQueen(board, sourcex, sourcey)
  else
    #tracePrint(piece.name)
    assert( isNullPiece(piece) )
  end
end

function legalKing(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveN(legal, board, piece, sourcex, sourcey)
  moveNE(legal, board, piece, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  moveS(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)
  #tracePrint( ("King", legal))
  return legal
end

function legalKnight(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  if piece.color == WHITE
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-1, sourcey+2)
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+1, sourcey+2)
  elseif piece.color == BLACK
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-1, sourcey-2)
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+1, sourcey-2)
  end
  tracePrint( ("Knight", legal), "legal")
  return legal
end

function legalPawn(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveForwards(legal, board, piece, sourcex, sourcey)
  tracePrint( ("Pawn", legal), "legal")
  return legal
end

function legalGold(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveN(legal, board, piece, sourcex, sourcey)
  moveS(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  if piece.color == WHITE
    moveNW(legal, board, piece, sourcex, sourcey)
    moveNE(legal, board, piece, sourcex, sourcey)
  elseif piece.color == BLACK
    moveSW(legal, board, piece, sourcex, sourcey)
    moveSE(legal, board, piece, sourcex, sourcey)
  else
    assert(false)
  end
  tracePrint( ("Gold", legal), "legal")
  return legal
end

function legalSilver(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  moveForwards(legal, board, piece, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)
  moveNE(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  tracePrint( ("Silver", legal), "legal")
  return legal
end

function legalLance(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  chainMovement(legal, board, piece, moveForwards, sourcex, sourcey)
  tracePrint( ("Lance", legal), "legal")
  return legal
end

function legalBishop(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
  tracePrint( ("Bishop", legal), "legal")
  return legal
end

function legalPBishop(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSE, sourcex, sourcey)

  moveN(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  moveS(legal, board, piece, sourcex, sourcey)
  tracePrint( ("PBishop", legal), "legal")
  return legal
end

function legalRook(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveN, sourcex, sourcey)
  chainMovement(legal, board, piece, moveE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveS, sourcex, sourcey)
  chainMovement(legal, board, piece, moveW, sourcex, sourcey)
  tracePrint( ("Rook", legal), "legal")
  return legal
end

function legalPRook(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveN, sourcex, sourcey)
  chainMovement(legal, board, piece, moveE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveS, sourcex, sourcey)
  chainMovement(legal, board, piece, moveW, sourcex, sourcey)

  moveNE(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)
  tracePrint( ("PRook", legal), "legal")
  return legal
end

######CHU SHOGI MOVES
function legalGoBetween(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveForwards(legal, board, piece, sourcex, sourcey)
  moveBackwards(legal, board, piece, sourcex, sourcey)
  tracePrint( ("Go-Between", legal), "legal")
  return legal
end

function legalSideMover(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveForwards(legal, board, piece, sourcex, sourcey)
  moveBackwards(legal, board, piece, sourcex, sourcey)
  chainMovement(legal, board, piece, moveE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveW, sourcex, sourcey)
  tracePrint( ("Side Mover", legal), "legal")
  return legal
end

function legalVerticalMover(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  chainMovement(legal, board, piece, moveN, sourcex, sourcey)
  chainMovement(legal, board, piece, moveS, sourcex, sourcey)
  tracePrint( ("Vertical Mover", legal), "legal")
  return legal
end

function legalChariot(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  chainMovement(legal, board, piece, moveForwards, sourcex, sourcey)
  chainMovement(legal, board, piece, moveBackwards, sourcex, sourcey)
  tracePrint( ("Reverse Chariot", legal), "legal")
  return legal
end

function legalTiger(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveNE(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  moveBackwards(legal, board, piece, sourcex, sourcey)
  tracePrint( ("Blind Tiger", legal), "legal")
  return legal
end

function legalLeopard(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveNE(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  moveForwards(legal, board, piece, sourcex, sourcey)
  moveBackwards(legal, board, piece, sourcex, sourcey)
  tracePrint( ("Ferocious Leopard", legal), "legal")
  return legal
end

function legalCopper(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveForwards(legal, board, piece, sourcex, sourcey)
  moveBackwards(legal, board, piece, sourcex, sourcey)
  if piece.color == WHITE
    moveNW(legal, board, piece, sourcex, sourcey)
    moveNE(legal, board, piece, sourcex, sourcey)
  elseif piece.color == BLACK
    moveSW(legal, board, piece, sourcex, sourcey)
    moveSE(legal, board, piece, sourcex, sourcey)
  else
    assert(false)
  end
  tracePrint( ("Copper General", legal), "legal")
  return legal
end

function legalElephant(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveNE(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  moveForwards(legal, board, piece, sourcex, sourcey)
  tracePrint( ("Drunken Elephant", legal), "legal")
  return legal
end

function legalKirin(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveNE(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex, sourcey+2)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex, sourcey-2)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+2, sourcey+2)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-2, sourcey)
  tracePrint( ("Kirin", legal), "legal")
  return legal
end

function legalPhoenix(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveN(legal, board, piece, sourcex, sourcey)
  moveS(legal, board, piece, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+2, sourcey+2)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+2, sourcey-2)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-2, sourcey+2)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-2, sourcey-2)
  tracePrint( ("Phoenix", legal), "legal")
  return legal
end

function legalQueen(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveN, sourcex, sourcey)
  chainMovement(legal, board, piece, moveE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveS, sourcex, sourcey)
  chainMovement(legal, board, piece, moveW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
  tracePrint( ("Queen", legal), "legal")
  return legal
end

function legalStag(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  moveE(legal, board, piece, sourcex, sourcey)
  moveW(legal, board, piece, sourcex, sourcey)
  moveSE(legal, board, piece, sourcex, sourcey)
  moveSW(legal, board, piece, sourcex, sourcey)
  moveNE(legal, board, piece, sourcex, sourcey)
  moveNW(legal, board, piece, sourcex, sourcey)

  chainMovement(legal, board, piece, moveForwards, sourcex, sourcey)
  chainMovement(legal, board, piece, moveBackwards, sourcex, sourcey)
  tracePrint( ("Flying Stag", legal), "legal")
  return legal
end

function legalOx(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveN, sourcex, sourcey)
  chainMovement(legal, board, piece, moveS, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
  tracePrint( ("Flying Ox", legal), "legal")
  return legal
end

function legalBoar(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
  tracePrint( ("Free Boar", legal), "legal")
  return legal
end

function legalWhale(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveN, sourcex, sourcey)
  chainMovement(legal, board, piece, moveS, sourcex, sourcey)
  if piece.color == WHITE
    chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
    chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
  elseif piece.color == BLACK
    chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
    chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  else
    assert(false)
  end
  tracePrint( ("Whale", legal), "legal")
  return legal
end

function legalWhiteHorse(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveN, sourcex, sourcey)
  chainMovement(legal, board, piece, moveS, sourcex, sourcey)

  if piece.color == WHITE
    chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
    chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  elseif piece.color == BLACK
    chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
    chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
  else
    assert(false)
  end
  tracePrint( ("White Horse", legal), "legal")
  return legal
end

function legalFalcon(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveBackwards, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveSW, sourcex, sourcey)


  moveForwards(legal, board, piece, sourcex, sourcey)
  tryToEnter(legal, board, piece, sourcex, sourcey, sourcex, sourcey+2)

  doubleMove(legal, board, piece, sourcex, sourcey, moveForwards, moveForwards)
  doubleMove(legal, board, piece, sourcex, sourcey, moveForwards, moveBackwards)
  tracePrint( ("Horned Falcon", legal), "legal")
  return legal
end

function legalEagle(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)

  chainMovement(legal, board, piece, moveE, sourcex, sourcey)
  chainMovement(legal, board, piece, moveW, sourcex, sourcey)
  chainMovement(legal, board, piece, moveBackwards, sourcex, sourcey)
  chainMovement(legal, board, piece, moveForwards, sourcex, sourcey)

  if piece.color == WHITE
    chainMovement(legal, board, piece, moveSE, sourcex, sourcey)
    chainMovement(legal, board, piece, moveSW, sourcex, sourcey)
    moveNE(legal, board, piece, sourcex, sourcey)
    moveNW(legal, board, piece, sourcex, sourcey)
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+2, sourcey+2)
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-2, sourcey+2)
    doubleMove(legal, board, piece, sourcex, sourcey, moveNE, moveNE)
    doubleMove(legal, board, piece, sourcex, sourcey, moveNW, moveNW)
    doubleMove(legal, board, piece, sourcex, sourcey, moveNE, moveSW)
    doubleMove(legal, board, piece, sourcex, sourcey, moveNW, moveSE)
  elseif piece.color == BLACK
    chainMovement(legal, board, piece, moveNE, sourcex, sourcey)
    chainMovement(legal, board, piece, moveNW, sourcex, sourcey)
    moveSE(legal, board, piece, sourcex, sourcey)
    moveSW(legal, board, piece, sourcex, sourcey)
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex+2, sourcey-2)
    tryToEnter(legal, board, piece, sourcex, sourcey, sourcex-2, sourcey-2)
    doubleMove(legal, board, piece, sourcex, sourcey, moveSE, moveSE)
    doubleMove(legal, board, piece, sourcex, sourcey, moveSW, moveSW)
    doubleMove(legal, board, piece, sourcex, sourcey, moveSE, moveNW)
    doubleMove(legal, board, piece, sourcex, sourcey, moveSW, moveNE)
  else
    assert(false)
  end
  tracePrint( ("Soaring Eagle", legal), "legal")
  return legal
end

function legalLion(board::Board, sourcex::Int, sourcey::Int)
  legal = Array{Move}(0)
  piece = getPiece(board, sourcex, sourcey)
  #Move once, same movements as king
  append!(legal, legalKing(board, sourcex, sourcey))
  #Jump
  for x = -2:2
    for y = -2:2
      targetx = sourcex + x
      targety = sourcey + y
      #lion immunity
      if targetx >= 1 && targety >= 1 && targetx <= BOARD_DIMENSIONS && targety <= BOARD_DIMENSIONS #if target in bounds
        if getPiece(board, targetx, targety).name == Lion
          newBoard = deepcopy(board)
          #simulates a board where the lion moved by stepping and killed an opposing lion
          updateBoard(newBoard, initMoveMovement(sourcex, sourcey, targetx, targety, nothing))
          #if the lion is not in danger of being killed, it's legal to move in
          if !isPieceInCheck(newBoard, targetx, targety)
            tryToEnter(legal, board, piece, sourcex, sourcey, targetx, targety)
          end
        #if the lion isnt killing a lion, its legal to move in
        else
          tryToEnter(legal, board, piece, sourcex, sourcey, targetx, targety)
        end
      end
    end
  end
  #double moves
  moves = [moveNW, moveN, moveNE, moveE, moveSE, moveS, moveSW, moveW]

  doubleLegal = Array{Move}(0)
  for i in moves
    for j in moves
      doubleMove(doubleLegal, board, piece, sourcex, sourcey, i, j)
    end
  end

  for i = 1:length(doubleLegal)
    if getPiece(board, doubleLegal[i].targetx2, doubleLegal[i].targety2).name == Lion
      newBoard = deepcopy(board)
      #simulates a board where the lion moved by stepping and killed an opposing lion
      updateBoard(newBoard, initMoveDoubleMovement(doubleLegal[i].sourcex, doubleLegal[i].sourcey, doubleLegal[i].targetx, doubleLegal[i].targety, nothing, doubleLegal[i].targetx2, doubleLegal[i].targety2))
      #if the lion is not in danger of being killed, it's legal to move in
      if !isPieceInCheck(newBoard, doubleLegal[i].targetx2, doubleLegal[i].targety2)
        push!(legal, doubleLegal[i])
      end
    #if the lion isnt killing a lion, its legal to move in
    else
      push!(legal, doubleLegal[i])
    end
  end

  tracePrint( ("Lion", legal), "legal")
  return legal
end












#Returns if the piece can be taken in the opponent's next move
function isPieceInCheck(board::Board, pieceLocX::Int, pieceLocY::Int)
  inCheck = false

  newBoard = board
  piece = getPiece(board, pieceLocX, pieceLocY)

  #set player to the opponent
  if getCurrentPlayer(newBoard) == piece.color
    newBoard = deepcopy(board)
    nextPlayer(newBoard)
  end

  enemyMoves = allLegalMovementMoves(newBoard)
  for i in 1:length(enemyMoves)
    if (enemyMoves[i].targetx == pieceLocX) && (enemyMoves[i].targety == pieceLocY)
      inCheck = true
      break
    end
  end

  return inCheck
end

function isPieceInCheck(board::Board, pieceLocX::Void, pieceLoxY::Void)
  return true #the piece does not exist. Let's pretend that makes it in check, to cut down on exploration of games with lost kings.
end

#Returns if the piece cannot make a move that will take it out of check #NOT OPTIMIZED BECAUSE NEVER USED
function isPieceInCheckMate(board::Board, pieceLocX::Int, pieceLocY::Int)
  inCheckMate = true

  newBoard = deepcopy(board)
  piece = getPiece(board, pieceLocX, pieceLocY)

  #set player to the piece's owner
  if getCurrentPlayer(newBoard) != piece.color
    nextPlayer(newBoard)
  end

  friendlyMoves = allLegalMoves(newBoard)
  for i in 1:length(friendlyMoves)
    #Make a board copy and do the move there
    newerBoard = deepcopy(newBoard)
    updateBoard(newerBoard, friendlyMoves[i])

    #For all enemy moves on that space, see if piece is still in check
    if !isPieceInCheck(newerBoard, pieceLocX, pieceLocY)
      inCheckMate = false
      break
    end
  end

  return inCheck
end
