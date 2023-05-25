enum Direction : CaseIterable{
  case North
  case East
  case South
  case West
  case NorthEast
  case NorthWest
  case SouthEast
  case SouthWest

  func translate() -> (Int,Int){
    switch self{
      case .North: return (-1,0)
      case .East: return (0,1)
      case .South: return (1,0)
      case .West: return (0,-1)
      case .NorthEast: return (-1,1)
      case .NorthWest: return (-1,-1)
      case .SouthEast: return (1,1)
      case .SouthWest: return (1,-1)
    }
  }
}