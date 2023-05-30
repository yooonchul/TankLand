extension TankLand{
  func doSetShieldAction(tank: Tank, shieldAction: ShieldAction) {
    let cost = shieldAction.power
    guard tank.energy > cost else {
      logger.printActionFailEnergy(tank.id,"SHIELD")
      return
    }
    tank.chargeEnergy(cost)
    tank.setShield(cost * Constants.shieldPowerMultiple)
    logger.printShield(tank.id,cost*Constants.shieldPowerMultiple)
  }

  func moveRover(rover:Mine){
    let cost = Constants.costOfMovingRover
    guard cost < rover.energy else{
      logger.printActionFailEnergy(rover.id,"ROVER MOVED")
      return
    }
    rover.chargeEnergy(Constants.costOfMovingRover)
    var newPosVal = Position(row:0,col:0)
if rover.moveInstruct == nil {
    newPosVal = newPosition(position: rover.position, direction: Direction.allCases.randomElement()!, magnitude: 1)
} else {
    newPosVal = newPosition(position: rover.position, direction: rover.moveInstruct!, magnitude: 1)
}
    
    if isGoodIndex(row:newPosVal.row,col:newPosVal.col){
      if grid[newPosVal.row][newPosVal.col] != nil{
        mineCollision(grid[newPosVal.row][newPosVal.col] ?? rover,rover)
        logger.printMineStrike(rover,grid[newPosVal.row][newPosVal.col] ?? rover)
      }else{
        grid[rover.position.row][rover.position.col] = nil
        grid[newPosVal.row][newPosVal.col] = rover
        rover.setPosition(newPosVal)
        logger.printMove(rover.id,newPosVal)
      }
    }
  }

  func runRadar(tank: Tank, radar: RadarAction){
    guard radar.range <= 9 && radar.range > 0 else{
      logger.printRunRadar(tank.id,radar.range,true)
      return
    }
    let cost = Constants.costOfRadarByUnitsDistance[radar.range]
    guard tank.energy > cost else{
      logger.printActionFailEnergy(tank.id,"radar")
      return
    }
    tank.chargeEnergy(cost)
    var arr = [RadarResult]()
    for row in tank.position.row-radar.range...tank.position.row+radar.range{
      for col in tank.position.col-radar.range...tank.position.col+radar.range{
        if isGoodIndex(row:row,col:col) && grid[row][col] != nil{
          arr.append(RadarResult(grid[row][col]!.position,grid[row][col]!.id,grid[row][col]!.energy))
        }
      }
    }
    tank.getRadar(arr)
    logger.printRunRadar(tank.id,radar.range,false)
  }

  func sendMessage(tank:Tank, messageAction:SendMessageAction) -> String?{
    let cost = Constants.costOfSendingMessage
    guard tank.energy > cost else{
      logger.printActionFailEnergy(tank.id,"SENDING MESSAGE")
      return nil
    }
    tank.chargeEnergy(cost)
    logger.printMessage(tank.id,"sent")
    return messageAction.message
  }

  func receiveMessage(tank:Tank, messageAction:ReceiveMessageAction, center:MessageCenter){
    let cost = Constants.costOfReceivingMessage
    guard tank.energy > cost else{
      logger.printActionFailEnergy(tank.id,"RECEIVING MESSAGE")
      return
    }
    tank.chargeEnergy(cost)
    logger.printMessage(tank.id,"received")
    tank.getMessage(MessageCenter.messages[messageAction.key])
  }

  func dropMine(tank:Tank, mineAction:MineAction){
    let tankPos = tank.position
    let dropPos = Position(row: tankPos.row + mineAction.dropDirection!.translate().0, col: tankPos.col + mineAction.dropDirection!.translate().1)

    if !isGoodIndex(row: dropPos.row, col: dropPos.col){
        logger.printDropMine(tank.id,(mineAction.isRover ? "rover":"mine"),dropPos,false)
        return
    }

    let cost = mineAction.power + (mineAction.isRover ? Constants.costOfReleasingRover : Constants.costOfReleasingMine)
    if grid[dropPos.row][dropPos.col] != nil{
        logger.printDropMine(tank.id,(mineAction.isRover ? "rover":"mine"),dropPos,true)
        return
    }
    if tank.energy < cost{
        logger.printActionFailEnergy(tank.id,(mineAction.isRover ? "ROVER":"MINE"))
        return
    }
    
    tank.chargeEnergy(cost)
  
    addGameObject(gameObject: Mine(owner: tank, id: "M" + threeDigitCenter(Mine.count), isRover: mineAction.isRover, position: dropPos, power: mineAction.power, moveInstruct: mineAction.moveDirection))

    return
}


func fireMissile(tank:Tank, missile:MissileAction){
    let cost = Constants.costOfLaunchingMissle + Constants.costOfFlyingMissilePerUnitDistance*Int(distanceCalc(tank.position,missile.target)) + missile.power
    guard tank.energy > cost else{
        logger.printActionFailEnergy(tank.id,"LAUNCHING MISSILE")
        return
    }
    tank.chargeEnergy(cost)
    var hitGOs = ""
    if isGoodIndex(row: missile.target.row, col: missile.target.col){
        for x in max(0, missile.target.row-1)...min(grid.count-1,missile.target.row+1){
            for y in max(0,missile.target.col-1)...min(grid[0].count-1,missile.target.col+1){
                if isGoodIndex(row:x,col:y) && grid[x][y] != nil{  
                    var force = missile.power
                    if missile.target != Position(row: x, col: y) {
                        force /= 4
                    }

                    hitGOs = "\(grid[x][y]!.id), "
                    if grid[x][y]!.type == .Tank{
                        let saveEnergy = grid[x][y]!.energy
                        let targetTank = grid[x][y]! as! Tank
                        targetTank.setShield(targetTank.shield > force ? targetTank.shield - force : 0)
                        force = shieldExtra(targetTank.shield,force)
                        tank.chargeEnergy(force*Constants.missileStrikeMultiple)
                        if tank.energy <= 0{
                            tank.gainEnergy(saveEnergy/Constants.missileEnergyTransfer)
                        }
                    }
                    else{
                        grid[x][y]!.chargeEnergy(grid[x][y]!.energy)
                    }
                }
            }
        }
    }
    logger.printMissileStrike(tank.id,missile.target,hitGOs)
}



  func moveTank(tank:Tank,moveAction:MoveAction){
    let newPosVal = newPosition(position:tank.position,direction:moveAction.direction,magnitude:moveAction.distance)
    guard isGoodIndex(row:newPosVal.row,col:newPosVal.col) else{
      logger.printTankMoveFail(tank.id,newPosVal,"OUT OF BOUNDS")
      return
    }
    guard 0<moveAction.distance && 3>=moveAction.distance else{
      logger.printTankMoveFail(tank.id,newPosVal,"CANNOT MOVE \(moveAction.distance) UNITS")
      return
    }
    if grid[newPosVal.row][newPosVal.col] != nil{
      guard grid[newPosVal.row][newPosVal.col]!.type != .Tank else{
        logger.printTankMoveFail(tank.id,newPosVal,"SPACE IS OCCUPIED BY \(grid[newPosVal.row][newPosVal.col]!.id)")
        return
      }
    }
    
    let cost = Constants.costOfMovingTankPerUnitDistance[moveAction.distance-1]
    guard tank.energy > cost else{
      logger.printActionFailEnergy(tank.id,"MOVE")
      return
    }
    
    if grid[newPosVal.row][newPosVal.col] != nil{
      mineCollision(tank,grid[newPosVal.row][newPosVal.col]! as! Mine)
    }
    
    tank.chargeEnergy(cost)
    grid[newPosVal.row][newPosVal.col] = tank
    grid[tank.position.row][tank.position.col] = nil
    tank.setPosition(newPosVal)
    logger.printMove(tank.id,newPosVal)
  }
  
}
