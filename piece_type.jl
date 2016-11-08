

##Pieces
type Piece
    color::AbstractString
    name::AbstractString
end

#Is a piece an empty square?
function isNullPiece(piece::Piece)
  return piece.name == "-"
end

#Are two pieces functionally identical? (Same colour and name)
function ==(a::Piece, b::Piece)
  return a.color == b.color && a.name == b.name
end

#Standard
const Bishop = "b"
const GoldGeneral = "g"
const King =  "k"
const Lance = "l"
const Knight = "n"
const Pawn =  "p"
const Rook = "r"
const SilverGeneral = "s"
#Chu shogi
const ReverseChariot = "a"
const CopperGeneral = "c"
const DragonKing = "d"
const DrunkenElephant = "e"
const FerociousLeopard = "f"
const DragonHorse = "h"
const Lion = "i"
const SideMover = "m"
const Kirin = "n" #same as knight
const GoBetween = "o"
const BlindTiger = "t"
const Queen = "q"
const VerticalMover = "v"
const Phoenix = "x"

#Standard
const PBishop = "B"
const PLance = "L"
const PKnight ="N"
const PPawn =  "P"
const PRook = "R"
const PSilverGeneral = "S"
#Chu Shogi
const PReverseChariot = "A"
const PCopperGeneral = "C"
const PDragonKing = "D"
const PDrunkenElephant = "E"
const PFerociousLeopard = "F"
const PDragonHorse = "H"
const PSideMover = "M"
const PKirin = "N" #same as knight
const PGoBetween = "O"
const PBlindTiger = "T"
const PVerticalMover = "V"
const PPhoenix = "X"

function promotePiece(piece::Piece)
  if piece.name == Pawn
    piece.name = PPawn
  elseif piece.name == Rook
    piece.name = PRook
  elseif piece.name == Bishop
    piece.name = PBishop
  elseif piece.name == Lance
    piece.name = PLance
  elseif piece.name == Knight #same as Kirin
    piece.name = PKnight
  elseif piece.name == SilverGeneral
    piece.name = PSilverGeneral
  #chu
  elseif piece.name == ReverseChariot
    piece.name = PReverseChariot
  elseif piece.name == CopperGeneral
    piece.name = PCopperGeneral
  elseif piece.name == DragonKing
    piece.name = PDragonKing
  elseif piece.name == DrunkenElephant
    piece.name = PDrunkenElephant
  elseif piece.name == FerociousLeopard
    piece.name = PFerociousLeopard
  elseif piece.name == DragonHorse
    piece.name = PDragonHorse
  elseif piece.name == SideMover
    piece.name = PSideMover
  elseif piece.name == VerticalMover
    piece.name = PVerticalMover
  elseif piece.name == GoBetween
    piece.name = PGoBetween
  elseif piece.name == BlindTiger
    piece.name = PBlindTiger
  elseif piece.name == Phoenix
    piece.name = PPhoenix
  end
end
function unpromotePiece(piece::Piece)
  if piece.name == PPawn
    piece.name = Pawn
  elseif piece.name == PRook
    piece.name = Rook
  elseif piece.name == PBishop
    piece.name = Bishop
  elseif piece.name == PLance
    piece.name = Lance
  elseif piece.name == PKnight
    piece.name = Knight
  elseif piece.name == PSilverGeneral
    piece.name = SilverGeneral
  end
end
