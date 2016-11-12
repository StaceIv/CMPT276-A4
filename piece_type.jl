

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
const Bishop = "bishop"
const GoldGeneral = "gold_general"
const King =  "king"
const Lance = "lance"
const Knight = "knight"
const Pawn =  "prince"
const Rook = "rook"
const SilverGeneral = "silver_general"
#Chu shogi
const ReverseChariot = "reverse_chariot"
const CopperGeneral = "copper_general"
const DragonKing = "dragon_king"
const DrunkenElephant = "drunken_elephant"
const FerociousLeopard = "ferocious_leopard"
const DragonHorse = "dragon_horse"
const Lion = "lion"
const SideMover = "side_mover"
const Kirin = "kirin"
const GoBetween = "go_between"
const BlindTiger = "blind_tiger"
const Queen = "queen"
const VerticalMover = "vertical_mover"
const Phoenix = "phoenix"
#Tenjiku Shogi
const BishopGeneral = "bishop_general"
const ChariotSoldier = "chariot_soldier"
const Dog = "dog"
const FireDemon = "fire_demon"
const FreeEagle = "free_eagle"
const GreatGeneral = "great_general"
const HornedFalcon = "horned_falcon"
const IronGeneral = "iron_general"
const LionHawk = "lion_hawk"
const RookGeneral = "rook_general"
const SideSoldier = "side_soldier"
const SoaringEagle = "soaring_eagle"
const VerticalSoldier = "vertical_soldier"
const ViceGeneral = "vice_general"
const WaterBuffalo = "water_buffalo"

#Standard                                           S/C/T
const PBishop = "promoted_bishop"                  #Dragon Horse
const PLance = "promoted_lance"                    #Gold General/White Horse
const PKnight = "promoted_knight"                  #Gold General/ /SIde Soldier
const PPawn =  "promoted_pawn"                     #Gold General
const PRook = "promoted_rook"                      #Dragon King
const PSilverGeneral = "promoted_silver_general"    #Gold General/Vertical Mover
#Chu Shogi
const PReverseChariot = "promoted_reverse_chariot"  #Whale
const PCopperGeneral = "promoted_copper_general"    #Side Mover
const PDragonKing = "promoted_dragon_king"          #Soaring Eagle
const PDrunkenElephant = "promoted_drunken_elephant"#Prince
const PFerociousLeopard = "promoted_ferocious_lepard"     #Bishop
const PDragonHorse = "promoted_dragon_horse"          #Horned Falcon
const PSideMover = "promoted_side_mover"            #Free Boar
const PKirin = "promoted_kirin"                #Lion
const PGoBetween = "promoted_go_between"            #Drunken Elephant
const pGoldGeneral = "promoted_gold_general"        #Rook
const PBlindTiger = "promoted_blind_tiger"           #Flying Stag
const PVerticalMover = "promoted_vertical_mover"        #Flying Ox
const PPhoenix = "promoted_phoenix"              #Queen
#Tenjiku Shogi
const PBishopGeneral = "promoted_bishop_general"  #Vice General
const PChariotSoldier = "promoted_bishop_general"   #Heavenly Tetrarch
const PDog = "promoted_dog"                       #Multi General
const PHornedFalcon = "promoted_horned_falcon"    #Bishop General
const PIronGeneral = "promoted_iron_general"      #Vertical Soldier
const PLion = "promoted_lion"                     #Lion Hawk
const PQueen = "promoted_queen"                   #Free Eagle
const PRookGeneral = "promoted_rook_general"      #Great General
const PSideSoldier = "promoted_side_soldier"      #Water Buffalo
const PSoaringEagle = "promoted_soaring_eagle"    #Rook General
const PVerticalSoldier = "promoted_vertical_soldier"    #Chariot Soldier
const PWaterBuffalo = "promoted_water_buffalo"     #Fire Demon


function promotePiece(piece::Piece)
  if piece.name == Pawn
    piece.name = PPawn
  elseif piece.name == Rook
    piece.name = PRook
  elseif piece.name == Bishop
    piece.name = PBishop
  elseif piece.name == Lance
    piece.name = PLance
  elseif piece.name == Knight
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
  elseif piece.name == Kirin
    piece.name = PKirin
  elseif piece.name == GoldGeneral
    piece.name = PGoldGeneral
  #Tenjiku
  elseif piece.name == BishopGeneral
    piece.name = PBishopGeneral
  elseif piece.name == ChariotSoldier
    piece.name = PChariotSoldier
  elseif piece.name == Dog
    piece.name = PDog
  elseif piece.name == HornedFalcon
    piece.name = PHornedFalcon
  elseif piece.name == IronGeneral
    piece.name = PIronGeneral
  elseif piece.name == Lion
    piece.name = PLion
  elseif piece.name == Queen
    piece.name = PQueen
  elseif piece.name == RookGeneral
    piece.name = PRookGeneral
  elseif piece.name == SideSoldier
    piece.name = PSideSoldier
  elseif piece.name == SoaringEagle
    piece.name = PSoaringEagle
  elseif piece.name == VerticalSoldier
    piece.name = PVerticalSoldier
  elseif piece.name == WaterBuffalo
    piece.name = PWaterBuffalo
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
    #chu
  elseif piece.name == PReverseChariot
    piece.name = ReverseChariot
  elseif piece.name == PCopperGeneral
    piece.name = CopperGeneral
  elseif piece.name == PDragonKing
    piece.name = DragonKing
  elseif piece.name == PDrunkenElephant
    piece.name = DrunkenElephant
  elseif piece.name == PFerociousLeopard
    piece.name = FerociousLeopard
  elseif piece.name == PDragonHorse
    piece.name = DragonHorse
  elseif piece.name == PSideMover
    piece.name = SideMover
  elseif piece.name == PVerticalMover
    piece.name = VerticalMover
  elseif piece.name == PGoBetween
    piece.name = GoBetween
  elseif piece.name == PBlindTiger
    piece.name = BlindTiger
  elseif piece.name == PPhoenix
    piece.name = Phoenix
  elseif piece.name == PKirin
    piece.name = Kirin
  elseif piece.name == PGoldGeneral
    piece.name = GoldGeneral
  #Tenjiku
  elseif piece.name == PBishopGeneral
    piece.name = BishopGeneral
  elseif piece.name == PChariotSoldier
    piece.name = ChariotSoldier
  elseif piece.name == PDog
    piece.name = Dog
  elseif piece.name == PHornedFalcon
    piece.name = HornedFalcon
  elseif piece.name == PIronGeneral
    piece.name = IronGeneral
  elseif piece.name == PLion
    piece.name = Lion
  elseif piece.name == PQueen
    piece.name = Queen
  elseif piece.name == PRookGeneral
    piece.name = RookGeneral
  elseif piece.name == PSideSoldier
    piece.name = SideSoldier
  elseif piece.name == PSoaringEagle
    piece.name = SoaringEagle
  elseif piece.name == PVerticalSoldier
    piece.name = VerticalSoldier
  elseif piece.name == PWaterBuffalo
    piece.name = WaterBuffalo
  end
end
