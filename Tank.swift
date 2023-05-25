// Tank.swift
// The code for the base Tank is given here
class Tank: GameObject {
    private (set) var shield: Int = 0
    var radarResults: [RadarResult]? = nil
    var receivedMessage: String?  = nil
    var preActions = [ActionType:PreAction]()
    var postActions = [ActionType:PostAction]()
    var instructions: String
    var message: String? = nil
    init(id: String, position: Position = Position(row:0, col:0), instructions: String = "") {
        self.instructions = instructions
        super.init(type: .Tank, id: id, position: position, energy: Constants.initialTankEnergy)
    }
    
    final func clearActions() {
        preActions = [ActionType:PreAction]()
        postActions =  [ActionType:PostAction]()
    }
    
    final func setShield(_ amount: Int) {
        self.shield = amount
    }
    
    final func setRadarResults(_ results: [RadarResult]?) {
        self.radarResults = results
    }
    
    final func setReceivedMessage(_ receivedMessage: String?) {
        self.receivedMessage = receivedMessage
    }
    
    final func addPreAction(preAction: PreAction) {
        preActions[preAction.action] = preAction
    }
    
    final func addPostAction(postAction: PostAction) {
        postActions[postAction.action] = postAction
    }
   func getRadar(_ results:[RadarResult]){
      radarResults = results
    }
    func getMessage(_ msg:String?){
      message = msg
    }
    func computePreActions() {
      
    }
    
    func computePostActions() {
    }
}

class TestTank: Tank{
  init(id: String, position: Position = Position(row:0,col:0)) {
    super.init(id: id, position: position, instructions: "")
  }
  
  func getRandomBool() -> Bool {
    return Bool.random()
  }
  
  override func computePreActions() {
    addPreAction(preAction: ShieldAction(power: 500))
    addPreAction(preAction: RadarAction(range: 5))
    addPreAction(preAction: SendMessageAction(id: "ABC", message: "test"))
    addPreAction(preAction: ReceiveMessageAction(key: "ABC"))
  }
    
    override func computePostActions() {
        if receivedMessage == "Test"{
          print("***MESSAGE SUCCESFULLY RECEIVED***")
        }
        if radarResults != nil{
            print("***Radar Results Received***")
            print("***Radar Results: \(radarResults!)")
        }
       
        addPostAction(postAction: MineAction(power: 500, isRover: getRandomBool(), dropDirection: .South, moveDirection: nil))
        addPostAction(postAction: MissileAction(power: 100, target: Position(row:6, col:8)))
        addPostAction(postAction: MoveAction(distance: 1, direction: .North))
       
    }
}