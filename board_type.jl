

##Board
type Board
  boardArray::Array
  turnNumber::Int
  playerResign::AbstractString #black or white
  whiteHand::Array
  blackHand::Array
end

#Get tthe piece from the given location
function getPiece(board::Board, inX::Int, inY::Int)
  return board.boardArray[inX, inY]
end
#Identical. The original function appeared undefined once, and this is the workaround.
# function getPiece2(board::Board, inX::Int, inY::Int) #for a reason I can't find, getPiece becomes undefined later. This is a short workaround. Note that undefined functions is not possible, according to julia docs.
#     return board.boardArray[inX, inY]
# end


#Sets the piece at a location to the given piece. This should be protected, and only called by updateBoard.
function setPiece(board::Board, inX::Int, inY::Int, piece::Piece) #DON'T USE THIS TO MOVE PIECES. USE UPDATEBOARD
  board.boardArray[inX, inY] = piece
end


#Returns the coordinates of the first instance of the piece it finds. Probably only useful for the king. Returns nothing if not found.
function findPiece(board::Board, piece::Piece)
  for x in 1:BOARD_DIMENSIONS
    for y in 1:BOARD_DIMENSIONS
      if board.boardArray[x,y] == piece
        return x, y
      end
    end
  end
  return nothing, nothing
end



#Determines and returns the board's current player.
function getCurrentPlayer(board::Board)
  if board.turnNumber % 2 == 1
    return BLACK
  else
    return WHITE
  end
end









##INITIALIZING BOARD
#whiteHand = initHand() #to add a new Piece to hand do: push!(whiteHand, Piece(WHITE,Pawn,false,[0,0],""))
#blackHand = initHand()

#Fills the boardArray with empty pieces
function emptyBoardArray(boardArray)
    for i = 1:BOARD_DIMENSIONS
        for j= 1:BOARD_DIMENSIONS
           boardArray[i,j] = Piece("","-")
        end
    end
    return boardArray
end


function fillInitialBoardArray(boardArray)

    if gameType == "standard"
      pieceNames = [
      "l" "-" "p" "-" "-" "-" "p" "-" "l"; #[1,1] - [1,9]
      "n" "b" "p" "-" "-" "-" "p" "r" "n"; #[2,1] - [2,9]
      "s" "-" "p" "-" "-" "-" "p" "-" "s"; #[3,1] - [3,9]
      "g" "-" "p" "-" "-" "-" "p" "-" "g"; #so on
      "k" "-" "p" "-" "-" "-" "p" "-" "k";
      "g" "-" "p" "-" "-" "-" "p" "-" "g";
      "s" "-" "p" "-" "-" "-" "p" "-" "s";
      "n" "r" "p" "-" "-" "-" "p" "b" "n";
      "l" "-" "p" "-" "-" "-" "p" "-" "l";
      ]
      for i = 1:BOARD_DIMENSIONS
        for j = 1:BOARD_DIMENSIONS
          boardArray[i,j].name = pieceNames[i,j]

          #color every piece
          if j<=3 && !isNullPiece(boardArray[i,j])
            boardArray[i,j].color = WHITE
          elseif j>=7 && !isNullPiece(boardArray[i,j])
            boardArray[i,j].color = BLACK
          end
        end
      end

      # for i = 1:BOARD_DIMENSIONS
      #   boardArray[i,3].name = Pawn
      #   boardArray[i,3].color = WHITE
      #   boardArray[i,7].name = Pawn
      #   boardArray[i,7].color = BLACK
      # end
      #
      # boardArray[1,1].name = Lance
      # boardArray[2,1].name = Knight
      # boardArray[3,1].name = SilverGeneral
      # boardArray[4,1].name = GoldGeneral
      # boardArray[5,1].name = King
      # boardArray[6,1].name = GoldGeneral
      # boardArray[7,1].name = SilverGeneral
      # boardArray[8,1].name = Knight
      # boardArray[9,1].name = Lance
      #
      # boardArray[2,2].name = Bishop
      # boardArray[8,2].name = Rook
      #
      # for i = 1:9
      #   boardArray[i,1].color = WHITE
      # end
      #
      # boardArray[2,2].color = WHITE
      # boardArray[8,2].color = WHITE
      #
      # boardArray[1,9].name = Lance
      # boardArray[2,9].name = Knight
      # boardArray[3,9].name = SilverGeneral
      # boardArray[4,9].name = GoldGeneral
      # boardArray[5,9].name = King
      # boardArray[6,9].name = GoldGeneral
      # boardArray[7,9].name = SilverGeneral
      # boardArray[8,9].name = Knight
      # boardArray[9,9].name = Lance
      #
      # boardArray[2,8].name = Rook
      # boardArray[8,8].name = Bishop
      #
      # for i = 1:9
      #   boardArray[i,9].color = BLACK
      # end
      #
      # boardArray[2,8].color = BLACK
      # boardArray[8,8].color = BLACK

    elseif gameType == "minishogi" #minishogi
      pieceNames = [
      "k" "p" "-" "-" "r"; #[1,1] - [1,5]
      "g" "-" "-" "-" "b"; #[2,1] - [2,5]
      "s" "-" "-" "-" "s"; #[3,1] - [3,5]
      "b" "-" "-" "-" "g"; #so on
      "r" "-" "-" "p" "k";
      ]
      for i = 1:BOARD_DIMENSIONS
        for j = 1:BOARD_DIMENSIONS
          boardArray[i,j].name = pieceNames[i,j]

          #color every piece
          if j<=2 && !isNullPiece(boardArray[i,j])
            boardArray[i,j].color = WHITE
          elseif j>=4 && !isNullPiece(boardArray[i,j])
            boardArray[i,j].color = BLACK
          end
        end
      end
      #
      # boardArray[5,1].name = Rook
      # boardArray[4,1].name = Bishop
      # boardArray[3,1].name = SilverGeneral
      # boardArray[2,1].name = GoldGeneral
      # boardArray[1,1].name = King
      # boardArray[1,2].name = Pawn
      #
      # for i = 1:5
      #   boardArray[i,1].color = WHITE
      # end
      # boardArray[1,2].color = WHITE
      #
      # boardArray[1,5].name = Rook
      # boardArray[2,5].name = Bishop
      # boardArray[3,5].name = SilverGeneral
      # boardArray[4,5].name = GoldGeneral
      # boardArray[5,5].name = King
      # boardArray[5,4].name = Pawn
      #
      # for i = 1:5
      #   boardArray[i,5].color = BLACK
      # end
      # boardArray[4,5].color = BLACK
    elseif gameType == "chu"
      pieceNames = [
      "l" "a" "m" "p" "-" "-" "-" "-" "p" "m" "a" "l" #[1,1] - [1,9]
      "f" "-" "v" "p" "-" "-" "-" "-" "p" "v" "-" "f" #[2,1] - [2,9]
      "c" "b" "r" "p" "-" "-" "-" "-" "p" "r" "b" "c" #[3,1] - [3,9]
      "s" "-" "h" "p" "o" "-" "-" "o" "p" "h" "-" "s" #so on
      "g" "t" "d" "p" "-" "-" "-" "-" "p" "d" "t" "g"
      "k" "n" "i" "p" "-" "-" "-" "-" "p" "i" "n" "k"
      "e" "x" "q" "p" "-" "-" "-" "-" "p" "q" "x" "e"
      "g" "t" "d" "p" "-" "-" "-" "-" "p" "d" "t" "g"
      "s" "-" "h" "p" "o" "-" "-" "o" "p" "h" "-" "s"
      "c" "b" "r" "p" "-" "-" "-" "-" "p" "r" "b" "c"
      "f" "-" "v" "p" "-" "-" "-" "-" "p" "v" "-" "f"
      "l" "a" "m" "p" "-" "-" "-" "-" "p" "m" "a" "l"
      ]
      for i = 1:BOARD_DIMENSIONS
        for j = 1:BOARD_DIMENSIONS
          boardArray[i,j].name = pieceNames[i,j]

          #color every piece
          if j<=5 && !isNullPiece(boardArray[i,j])
            boardArray[i,j].color = WHITE
          elseif j>=8 && !isNullPiece(boardArray[i,j])
            boardArray[i,j].color = BLACK
          end
        end
      end
    else
      assert(false)
    end
  return boardArray
end

function initBoard()
  return Board(initBoardArray(), 1, "",  initHand(), initHand())
end

function initBoardArray()
  initialBoardArray = Array{Piece}(BOARD_DIMENSIONS, BOARD_DIMENSIONS) #EMPTY
  initialBoardArray = emptyBoardArray(initialBoardArray)
  return fillInitialBoardArray(initialBoardArray)
end

function initHand()
  return Array{Piece}(0)
end

function addToHand(board, player::AbstractString, piece::Piece)
  if player == WHITE || player == BLACK
    push!( handForPlayer(board, player), piece )
  else
    assert(false)
  end
end

function handForPlayer(board::Board, color::AbstractString)
  if color == WHITE
    return board.whiteHand
  elseif  color == BLACK
    return board.blackHand
  else
    assert(false)
  end
end
