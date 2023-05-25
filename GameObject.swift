// GameObject.swift
// The actual code for a GameObject is given here
class GameObject: CustomStringConvertible {
    let type: GameObjectType
    let id: String
    private (set) var position: Position
    private (set) var energy: Int
    var description: String {return "ID: \(id), Type: \(type), Energy: \(energy), Position: \(position)"}
    
    init(type: GameObjectType, id: String, position: Position, energy: Int) {
        self.type = type
        self.id = id
        self.position = position
        self.energy = energy
    }
    
    final func chargeEnergy(_ amount: Int) {
        self.energy -= amount
    }
    
    final func gainEnergy(_ amount: Int) {
        self.energy += amount
    }
    
    final func setPosition(_ newPosition: Position) {
        self.position = newPosition
    }
}