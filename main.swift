//Yoonchul and Jeffrey


var grid = TankLand(numberRows: 15, numberCols: 15, tanks: []) 

grid.populateTankLand()

while !grid.gameOver{
  grid.doTurn()
}



// init(id: String, position: Position = Position(0, 0), instructions: String = "") {
//         self.instructions = instructions
//         super.init(type: .Tank, id: id, position: position, energy: Constants.initialTankEnergy)
//     }