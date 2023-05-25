struct Position: CustomStringConvertible, Equatable {
    var row: Int
    var col: Int
    
    init(row:Int, col:Int){
        self.row = row
        self.col = col
    }
    
    var description: String {
        return("\(row),\(col)")
    }
    
    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
}
