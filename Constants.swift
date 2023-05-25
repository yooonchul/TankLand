  //Constants.swift contains a struct whose properties are all static constant values that define the 
// TankLand system. One example is shown.
struct Constants{
  static let initialTankEnergy = 100000
  static let costOfRadarByUnitsDistance = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12400]
  static let costOfSendingMessage = 100
  static let costOfReceivingMessage = 100
  static let costOfReleasingMine = 250
  static let costOfReleasingRover = 500
  static let costOfLaunchingMissle = 1000
  static let costOfFlyingMissilePerUnitDistance = 200
  static let costOfMovingTankPerUnitDistance = [100, 300, 600]
  static let costOfMovingRover = 50
  static let costLifeSupportTank = 100
  static let costLifeSupportRover = 40
  static let costLifeSupportMine = 20
  static let missileStrikeMultiple = 10
  static let missileStrikeMultipleCollateral = 3
  static let mineStrikeMultiple = 5
  static let shieldPowerMultiple = 8
  static let missileStrikeEnergyTransferFraction = 4
  static let missileEnergyTransfer = 4
}
 
 