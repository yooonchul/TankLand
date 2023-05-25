class Mine: GameObject{
  var moveInstruct: Direction?
  var isRover: Bool
  var owner: Tank
  static var count = 0
  init(owner: Tank, id: String, isRover: Bool, position: Position, power: Int, moveInstruct: Direction? = nil){
    var type:GameObjectType
    self.owner = owner
    self.isRover = isRover
    self.moveInstruct = moveInstruct
    Mine.count += 1
    if isRover{
      type = .Rover
    }
    else{
      type = .Mine
    }
    super.init(type:type, id: id, position: position, energy: power)
  }
}