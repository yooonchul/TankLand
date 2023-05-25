//TankLandDisplay contains the code that prints the grid
extension TankLand{
  func printGrid(){
      var string = ""
      for u in 0..<15 {
          for _ in 0..<15 {
              string += "--------"
          }
          string += "\n"
          for z in 0..<4 {
              for col in 0..<15 {
                if grid[u][col] != nil{
                  if z == 0 {
                    if grid[u][col]!.energy > 99999{
                      string += "| \(grid[u][col]!.energy)"
                    }else if grid[u][col]!.energy > 9999{
                      string += "|  \(grid[u][col]!.energy)"
                    }else if grid[u][col]!.energy > 999{
                      string += "|   \(grid[u][col]!.energy)"
                    }else if grid[u][col]!.energy > 99{
                      string += "|    \(grid[u][col]!.energy)"
                    }else if grid[u][col]!.energy > 9{
                      string += "|     \(grid[u][col]!.energy)"
                    }
                } else if z == 1 {
                  string += "|\(grid[u][col]!.id)   "
                } else if z == 2 {
                    if u > 9 && col > 9{
                      string += "|(\(grid[u][col]!.position))"
                      continue
                    }else if u > 9 || col > 9{
                      string += "|(\(grid[u][col]!.position)) "
                      continue
                    }
                    string += "|(\(grid[u][col]!.position))  "
                  }else if z == 3{
                    string += "|       "
                  }
                } else {
                  string += "|       "
                }
              }
              string += "|\n"
          }
      }
      for _ in 0..<15 {
          string += "--------"
      }
      string += "\n"
      print(string)
  }
}