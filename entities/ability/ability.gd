extends Resource
class_name Ability

@export var name: String
@export var attack_cooldown: float = 1.0

## visitors called as soon as they are added to the 
## ability controller
@export var passive: Array[Visitor]
@export var on_attack: Array[Visitor]
@export var on_special: Array[Visitor]
@export var on_ultimate: Array[Visitor]

@export var on_hit_ball: Array[Visitor]
@export var on_hit_by_ball: Array[Visitor]
