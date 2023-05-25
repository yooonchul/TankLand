protocol Action: CustomStringConvertible {
  var  action: ActionType {get}
  var description: String {get}
}
 
protocol PreAction: Action{}
protocol PostAction: Action{}
 

struct ShieldAction: PreAction {
  let action: ActionType
  let power: Int
  var description: String {return "\(action) \(power)"}
  init(power: Int){
    action = .Shield
    self.power = power
  }
}

struct RadarAction: PreAction {
  let action: ActionType
  let range: Int
  var description: String {return "\(action) \(range)"}
  init(range: Int) {
    action = .Radar
    self.range = range
  }
}

struct MoveAction: PostAction {
  let action: ActionType
  let distance: Int
  let direction: Direction
  var description: String {return "\(action) \(direction) \(distance)"}
  init(distance: Int, direction: Direction) {
    action = .Move
    self.distance = distance
    self.direction = direction
  }
}

struct MineAction: PostAction {
    let action: ActionType
    let isRover: Bool
    let power: Int
    let dropDirection: Direction?
    let moveDirection: Direction?
    var description: String {
        let dropDirectionMessage = (dropDirection == nil) ? "drop direction is random" : "\(dropDirection!)"
        let moveDirectionMessage = isRover ? ((moveDirection == nil) ? "move direction is random" : "\(moveDirection!)") : ""
        return "\(action) \(power) \(dropDirectionMessage) \(isRover) \(moveDirectionMessage)"
    }
    init(power: Int, isRover: Bool = false, dropDirection: Direction? = nil,  moveDirection: Direction? = nil){
        action = .DropMine
        self.isRover = isRover
        self.dropDirection = dropDirection
        self.moveDirection = moveDirection
        self.power = power
    }
}

struct MissileAction: PostAction{
  let action: ActionType
  let power: Int
  let target: Position
  var description: String {
    return "\(action) \(power) \(target)"
  }
  
  init(power: Int, target: Position){
    action = .Missile
    self.power = power
    self.target = target
  }
}

struct SendMessageAction: PreAction{
  let action: ActionType
  let id: String
  let message: String
  var description: String {
    return "\(action) \(id) \(message)"
  }
  init(id: String, message: String){
    action = .SendMessage
    self.id = id
    self.message = message
  }
}

struct ReceiveMessageAction: PreAction{
  let action: ActionType
  let key: String
  var description: String {
    return "\(action) \(key)"
  }
  init(key: String){
    action = .ReceiveMessage
    self.key = key
  }
}

 
enum ActionType{
  case Move, Shield, Radar, DropMine, Missile, SendMessage, ReceiveMessage
}
