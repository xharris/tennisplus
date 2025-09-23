extends Resource
class_name Ability

enum ActivationType {
    ## activated immediately
    Passive,
    ## can be activated after accumulating enough charge [0, 100]
    Charge,
    ## activated once player is on the last life
    LastLife
}

@export var name: String
@export var type: ActivationType

@export var on_activate: Array[Visitor]
@export var on_hit_ball: Array[Visitor]
@export var on_hit_by_ball: Array[Visitor]
