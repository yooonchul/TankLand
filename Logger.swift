struct Logger{
  var turn:Int = 0

  func printAddTank(_ tank:Tank){
    print("\(turn) \(tank.id) HAS BEEN ADDED TO THE WORLD AT \(tank.position)")
  }

  mutating func printTurnStart(){
    turn += 1
print("*************************************************************************************************************************")
    print("TURN #\(turn)")
  }
  
  func printDeath(_ go:GameObject){
    switch go.type{
      case .Tank: print("\(turn) \(go.id) HAS DIED AND HAS BEEN REMOVED FROM THE WORLD ")
      case .Mine: print("\(turn) \(go.id) DROPPED BY \((go as! Mine).owner.id) HAS DIED AND HAS BEEN REMOVED FROM THE WORLD")
      default: let _ = ""
    }
  }

  func printMineStrike(_ mine:Mine,_ go:GameObject){
    switch go.type{
      case .Tank: print("\(turn) \(go.id) COLLIDED WITH \(mine.id) DROPPED BY \(mine.owner.id), TAKING \(mine.energy*Constants.mineStrikeMultiple) DAMAGE \u{1F4A5}")
      case .Mine,.Rover: print("\(turn) \(mine.id) COLLIDED WITH \(go.id) AND DETONATED EACH OTHER")
    }
  }

  func printActionFailEnergy(_ id:String,_ action:String){
    print("\(turn) \(action) FAILED...\(id) DOES NOT HAVE ENOUGH ENERGY")
  }

  func printMissileStrike(_ id:String,_ target:Position,_ hitGOs:String){
    if hitGOs == ""{
      print("\(turn) \(id) launched a missile to \(target): THE SPACE IS EMPTY")
    }
    else{
      print("\(turn) \(id) launched a missile to \(target): HIT \(hitGOs)")
    }
  }

  func printTankMoveFail(_ id:String,_ pos:Position,_ error:String){
    print("\(turn) \(id) attempted to move to \(pos) but failed: \(error)")
  }

  func printMove(_ id:String,_ newPos:Position){
    print("\(turn) \(id) moved to \(newPos)")
  }

  func printMessage(_ id:String,_ action:String){
    print("\(turn) \(id) \(action) a message")
  }

  func printRunRadar(_ id:String,_ range:Int,_ fail:Bool){
    if fail{
      print("\(turn) \(id) attempted to run its radar but failed: CANNOT RUN RADAR \(range) UNITS")
    } else{
      print("\(turn) \(id) has run its radar: \(range) UNITS")
    }
  }

  func printDropMine(_ id: String, _ type: String, _ dropPos: Position, _ fail: Bool, _ energy: Int? = nil) {
    if fail {
        print("\(turn) \(id) attempted to drop a \(type) at \(dropPos) but failed: SPACE IS OCCUPIED")
    } else {
        if let energy = energy {
            print("\(turn) \(id) dropped a \(type) at \(dropPos) with \(energy) energy")
        } else {
            print("\(turn) \(id) dropped a \(type) at \(dropPos) but energy is nil")
        }
    }
}


  func printShield(_ id:String,_ size:Int){
    print("\(turn) SHIELD ADDED...\(id) SET SHIELD TO \(size)")
  }
}