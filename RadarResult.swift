//RadarResult.swift defines a structure that contains the result of radar on a location containing a 
struct RadarResult{
    var position:Position
    var id:String
    var energy:Int
    init(_ position:Position,_ id: String,_ energy:Int){
       self.position = position
       self.id = id
       self.energy = energy
   }
}