import Foundation

extension TankLand{
  func newPosition(position: Position, direction: Direction, magnitude: Int)->Position{
    var newPosVal = position
      newPosVal.row += magnitude*direction.translate().0
      newPosVal.col += magnitude*direction.translate().1
    return newPosVal
}
  func isGoodIndex(row: Int, col: Int)->Bool{
    if 0 <= row && row < grid.count && 0 <= col && col < grid.count{
      return true
    }
    return false
  }
  func randomizeGameObjects(gameObjects: [GameObject]) -> [GameObject]{
   return gameObjects.shuffled()
 }
  func lifeSupport(_ allObjects:[GameObject]){
    for obj in allObjects{
      switch obj.type{
        case .Tank: obj.chargeEnergy(Constants.costLifeSupportTank)
        case .Mine: obj.chargeEnergy(Constants.costLifeSupportMine)
        case .Rover: obj.chargeEnergy(Constants.costLifeSupportRover)
      }
    }
    doDeathCheck()
  }
  func doWinCheck() -> Bool{
    if findAllTanks().count == 1{
      setWinner(lastTankStanding: findAllTanks()[0])
      return true
    }
    else{
      return false
    }
  }
    func doDeathCheck(){
    for obj in findAllGameObjects(){
      if !isAlive(obj){
        setDead(obj)
        logger.printDeath(obj)
        if doWinCheck(){
          return
        }
      }
    }
  }
  func isAlive(_ go:GameObject) -> Bool{
    return go.energy > 0
  }
  func setDead(_ go:GameObject){
    grid[go.position.row][go.position.col] = nil
  }

  func shieldExtra(_ shieldAmt:Int,_ forceAmt:Int) -> Int{
    if shieldAmt >= forceAmt{
      return 0
    }
    else{
      return forceAmt-shieldAmt
    }
  }

  func mineCollision(_ go:GameObject,_ mine:Mine){
    var force = mine.energy*Constants.mineStrikeMultiple
    switch go.type{
      case .Mine,.Rover: setDead(go)
                         setDead(mine)
      case .Tank: (go as! Tank).setShield((go as! Tank).shield > force ? (go as! Tank).shield-force : 0)
                  force = shieldExtra((go as! Tank).shield,force)
                  go.chargeEnergy(force)
                  setDead(mine)
    }
    logger.printMineStrike(mine,go)
  }
  func findAllGameObjects()->[GameObject]{
    var allGO = [GameObject]()
    for row in grid{
      for space in row{
        if space != nil{
          allGO.append(space!)
        }
      }
    }
    return allGO
  }
  func findAllRovers() -> [Mine]{
    let allGO = findAllGameObjects()
    var allRover = [Mine]()
    for obj in allGO{
      if obj.type == .Rover{
        allRover.append(obj as! Mine)
      }
    }
    return allRover
  }
  func findAllTanks()->[Tank]{
    let allGO = findAllGameObjects()
    var allTank = [Tank]()
    for obj in allGO{
      if obj.type == .Tank{
        allTank.append(obj as! Tank)
      }
    }
    return allTank
  }
    func distanceCalc(_ pos1:Position,_ pos2:Position)->Double{
    return sqrt(pow(Double(pos1.row-pos2.row),2.0)+pow(Double(pos1.col-pos2.col),2.0))
  }
  func threeDigitCenter(_ number: Int) -> String {
    return String(format: "%03d", number)
}
}
