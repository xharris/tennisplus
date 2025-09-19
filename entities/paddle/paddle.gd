extends Node2D
class_name Paddle

#signal connected_exports

var _log = Logger.new("paddle")
@onready var hitbox_controller: PaddleHitboxController = $HitboxContoller
@onready var ability_controller: AbilityController = $AbilityController
@onready var health_controller: HealthController = $Health

@export var abilities: Array[Ability]:
    set(v):
        abilities = v
        if ability_controller:
            ability_controller.abilities = abilities
@export var input: InputController:
    set(v):
        input = v
        if is_inside_tree():
            _connect_exports()

func accept(v: Visitor):
    if v is PaddleVisitor:
        v.visit_paddle(self)
    if v is HealthVisitor:
        v.visit_health(health_controller)

func set_log_prefix(prefix: String):
    name = "%s-paddle" % [prefix]
    _log.set_prefix(prefix)
    hitbox_controller.set_log_prefix(prefix)
    health_controller.set_log_prefix(prefix)
    ability_controller.set_log_prefix(prefix)

func _ready() -> void:
    add_to_group(Groups.PADDLE)
    
    _connect_exports()
    hitbox_controller.hit.connect(ability_controller.hit)
    hitbox_controller.accepted_visitor.connect(accept)
    ability_controller.accepted_visitor.connect(accept)
    health_controller.area2d.body_entered_once.connect(ability_controller.hit_by)
    health_controller.damage_taken.connect(ability_controller.take_damage)
    
    ability_controller.abilities = abilities
    ability_controller.next_ability()

func _connect_exports():
    if not input:
        _log.warn_if(is_inside_tree(), "no input configured")
        return
    input.ability.connect(ability_controller.activate)
    #connected_exports.emit()
