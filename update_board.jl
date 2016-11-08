function updateBoard(board::Board, move::Move)
  #MOVEMENT
  if isMoveMovement(move)
    #Should a piece be captured?
    targetPiece = getPiece(board, move.targetx, move.targety)
    if ! isNullPiece(targetPiece)
      addToHand( board, getCurrentPlayer(board), targetPiece )
    end

    #Replace the target square with the moved piece
    tempPiece = getPiece(board, move.sourcex, move.sourcey)
    if move.option == "!"
      promotePiece(tempPiece)
    end

    #set piece after update
    setPiece(board, move.targetx, move.targety, tempPiece)

    #Remove piece from initial space
    newPiece = Piece("","-")
    setPiece(board, move.sourcex, move.sourcey, newPiece)

    #second move, for pieces that move twice
    #moving from square (targetx, targety) to square (targetx2, targety2)
    if move.targetx2 != nothing && move.targety2 != nothing
      #Should a piece be captured?
      targetPiece = getPiece(board, move.targetx2, move.targety2)
      if ! isNullPiece(targetPiece)
        addToHand( board, getCurrentPlayer(board), targetPiece )
      end

      #Replace the target square with the moved piece
      #set piece after update
      setPiece(board, move.targetx2, move.targety2, tempPiece)

      #Remove piece from initial space
      setPiece(board, move.targetx, move.targety, newPiece)
    end


  #DROP
  elseif isMoveDrop(move)
    setPiece(board, move.targetx, move.targety, move.option)

    #=Go through each piece in the current player's hand, checking if it matches the piece you're currently dropping.
    If so, remove that piece from the hand. (note that updateBoard doesnt care if the piece you're dropping
    was in your hand, or if the dropping is legal)=#
    currentHand = handForPlayer(board, getCurrentPlayer(board))
    for i in 1:length(currentHand)
      if currentHand[i].name == move.option.name
        deleteat!(currentHand, i) #removes the piece at index i from the currentHand array
        break
      end
    end

    #update hand
    if getCurrentPlayer(board) == BLACK
      board.blackHand = currentHand
    elseif getCurrentPlayer(board) == WHITE
      board.whiteHand = currentHand
    end

    #set piece to your color
    getPiece(board, move.targetx, move.targety).color = getCurrentPlayer(board)

    unpromotePiece(getPiece(board, move.targetx, move.targety))


  #RESIGN
  elseif isMoveResign(move)
    #tracePrint( ("updateBoard with RESIGN", move) )
    board.playerResign = getCurrentPlayer(board)

  else
    assert(false)
  end


  nextPlayer(board)
end





# ##MOVEMENT
# function updateBoard(board::Board, move::Tuple{Tuple{Int, Int}, Tuple{Int, Int}, Bool})
#   assert(false)
#   sourcex = move[1][1]
#   sourcey = move[1][2]
#   targetx = move[2][1]
#   targety = move[2][2]
#   promote = move[3]
#
#   #tracePrint( ("updateBoard with a movement", move) )
#
#   #Should a piece be captured?
#   targetPiece = getPiece2(board, targetx, targety)
#   if ! isNullPiece(targetPiece)
#     addToHand( board, getCurrentPlayer(board), targetPiece )
#   end
#
#   #Replace the target square with the moved piece
#   tempPiece = getPiece(board, sourcex, sourcey)
#   if promote == true
#     promotePiece(tempPiece)
#   end
#
#   #set piece after update
#   setPiece(board, targetx, targety, tempPiece)
#
#   #Remove piece from initial space
#   newPiece = Piece("","-")
#   setPiece(board, sourcex, sourcey, newPiece)
#
#   nextPlayer(board)
#   #tracePrint( "updateBoard success" )
# end
#
#
# #DROP
# function updateBoard(board::Board, move::Tuple{Piece, Tuple{Int, Int}})
#   assert(false)
#   targetx = move[2][1]
#   targety = move[2][2]
#   piece = move[1]
#
#   #tracePrint( ("updateBoard with a drop", move) )
#
#   setPiece(board, targetx, targety, piece)
#
#   #=Go through each piece in the current player's hand, checking if it matches the piece you're currently dropping.
#   If so, remove that piece from the hand. (note that updateBoard doesnt care if the piece you're dropping
#   was in your hand, or if the dropping is legal)=#
#   currentHand = handForPlayer(board, getCurrentPlayer(board))
#   for i in 1:length(currentHand)
#     if currentHand[i].name == piece.name
#       deleteat!(currentHand, i) #removes the piece at index i from the currentHand array
#       break
#     end
#   end
#
#   #update hand
#   if getCurrentPlayer(board) == BLACK
#     board.blackHand = currentHand
#   elseif getCurrentPlayer(board)==WHITE
#     board.whiteHand = currentHand
#   end
#
#   #set piece to your color
#   getPiece(board, targetx, targety).color = getCurrentPlayer(board)
#
#   unpromotePiece(getPiece(board,targetx,targety))
#
#   nextPlayer(board)
#   #tracePrint( "updateBoard success" )
# end
#
# ##RESIGN
# function updateBoard(board::Board, move::AbstractString)
#   assert(false)
#
#   #tracePrint( ("updateBoard with RESIGN", move) )
#   board.playerResign = getCurrentPlayer(board)
#
#   nextPlayer(board)#May be useful for ai board scoring.
#   #tracePrint( "updateBoard success" )
# end
#
#
#
function nextPlayer(board::Board)
  board.turnNumber = board.turnNumber + 1
end
