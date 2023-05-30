//The TankLand Class runs the TankLand game. The class is large enough that it is split into three 
//separate files using Swift extension:
//TankLand - holds the grid, all properties, and runs the turns
//TankLandSupport - contains the most important helper methods,
//TankLandActions contains the code that implements the actions; the most complex code in TankLand
class TankLand  {
    var grid: [[GameObject?]]
    var numberRows: Int
    var numberCols: Int
    var gameOver = false
    var tanks: [Tank]
    var logger = Logger()
    var lastLivingTank: GameObject? 
    init(numberRows: Int, numberCols: Int, gameOver: Bool = false, tanks:[Tank]){
        grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)   
      self.numberRows = numberRows
      self.numberCols = numberCols
      self.gameOver = gameOver
      self.tanks = tanks
    }
    
    func setWinner(lastTankStanding: Tank){
        gameOver = true
        lastLivingTank = lastTankStanding
    }
    
    func addGameObject(gameObject: GameObject){
    if isGoodIndex(row: gameObject.position.row, col: gameObject.position.col){
	     self.grid[gameObject.position.row][gameObject.position.col] = gameObject
    } else {
      print("ERROR: OUT OF BOUNDS")
    }
    }
  //changed from grid.count to numberRows/cols
func randomPos() -> Position {
    let x = Int.random(in: 0..<numberRows)
    let y = Int.random(in: 0..<numberCols)
    return Position(row: x, col: y)
}

func populateTankLand() {
    addGameObject(gameObject: TestTank(id: "MAN1",position:randomPos()))
    addGameObject(gameObject: TestTank(id: "MAN4",position:randomPos()))
}

    

  func doTurn(){
    var turn = 0
    turn += 1
    logger.printTurnStart()
    var allObjects = findAllGameObjects()
    tanks = findAllTanks()
    allObjects = randomizeGameObjects(gameObjects: allObjects)
    lifeSupport(allObjects)
    let messageCenter = MessageCenter()
    var rovers = findAllRovers()
    for obj in rovers{
      moveRover(rover:obj)
      doDeathCheck()
      if doWinCheck(){
        return
      }
      rovers = findAllRovers()
    }
      tanks.shuffle()
    print("\n*****COMPUTING PRE ACTIONS*****")
    //radar
      for i in tanks{
        i.computePreActions()
            for j in i.preActions{
              if let radr = j.1 as? RadarAction{
                runRadar(tank: i, radar: radr)
              }
          }
      }
    //msg
      for i in tanks {
          i.computePreActions()
          for j in i.preActions {
              if let smsg = j.1 as? SendMessageAction {
                  MessageCenter.sendMessage(id: smsg.id, message: sendMessage(tank: i, messageAction: smsg) ?? "error")
              }
          }
      }
    //rmsg
      for i in tanks{
                i.computePreActions()
            for j in i.preActions{
              if let rmsg = j.1 as? ReceiveMessageAction{
              receiveMessage(tank:i, messageAction:rmsg, center:messageCenter)
          } 
          }
      }
      //shieldaction
      for i in tanks{
                i.computePreActions()
            for j in i.preActions{
              if let shld = j.1 as? ShieldAction{
                 doSetShieldAction(tank:i, shieldAction:shld)
              }
          }
      }
      tanks.shuffle()
    print("\n*****COMPUTING POST ACTIONS*****")
    //missle, move, mine 
  var tanksToClear = [Tank]()  
  for i in tanks {
      i.computePostActions()
      for x in i.postActions {
        
          if let move = x.1 as? MoveAction{
              moveTank(tank:i, moveAction:move)
          }
          if let mine = x.1 as? MineAction {
              dropMine(tank:i, mineAction:mine)
          }
          if let mssle = x.1 as? MissileAction {
              fireMissile(tank:i, missile:mssle)
          }
      }
      tanksToClear.append(i)
  }
  for tank in tanksToClear {
      tank.clearActions()
  }
  printGrid()
  }


    func getUserCommand() -> String{
    print("Command", terminator:"...")
    return readLine()!
  }
      func runGame(){
        populateTankLand()
        tanks = findAllTanks()
        print("WELCOME TO TANKLAND.\nTURN #0")
        for i in tanks{
        logger.printAddTank(i)
      }
        while !gameOver {
        var command = getUserCommand()
        if command == ""{
          doTurn()
        }
        command = ""
}
        print("Winner is...\(lastLivingTank!)!")
    }
  }
   

