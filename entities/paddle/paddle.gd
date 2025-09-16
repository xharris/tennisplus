extends Node2D
class_name Paddle

var _log = Logger.new("paddle")
@onready var _hitbox_controller: PaddleHitboxController = $HitboxContoller
@onready var _ability_controller: AbilityController = $AbilityController
@onready var _health_controller: HealthController = $Health

@export var abilities: Array[Ability]
@export var input: InputController:
    set(v):
        input = v
        if is_inside_tree():
            _connect_exports()

func accept(v: Visitor):
    if v is PaddleVisitor:
        v.visit_paddle(self)
    if v is HealthVisitor:
        v.visit_health(_health_controller)

func set_log_prefix(prefix: String):
    name = "%s-paddle" % [prefix]
    _log.set_prefix(prefix)
    _hitbox_controller.set_log_prefix(prefix)
    _health_controller.set_log_prefix(prefix)
    _ability_controller.set_log_prefix(prefix)

func _ready() -> void:
    add_to_group(Groups.PADDLE)
    
    _connect_exports()
    _hitbox_controller.hit.connect(_ability_controller.hit)
    _hitbox_controller.accepted_visitor.connect(accept)
    _ability_controller.accepted_visitor.connect(accept)
    #_ability_controller.activated.connect(_on_ability_activated)
    _health_controller.area2d.body_entered_once.connect(_ability_controller.hit_by)
    _health_controller.damage_taken.connect(_ability_controller.take_damage)

    _ability_controller.abilities = abilities
    _ability_controller.next_ability()

func _connect_exports():
    if not input:
        _log.warn_if(is_inside_tree(), "no input configured")
        return
    input.attack.connect(_hitbox_controller.attack)
    input.ability.connect(_ability_controller.activate)
