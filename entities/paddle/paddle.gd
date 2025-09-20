extends Node2D
class_name Paddle

var _log = Logger.new("paddle")#, Logger.Level.DEBUG)
@onready var hitbox_controller: PaddleHitboxController = $HitboxContoller
@onready var ability_controller: AbilityController = $AbilityController
@onready var health_controller: HealthController = $Health

@export var abilities: Array[Ability]:
    set(v):
        abilities = v
        if ability_controller:
            ability_controller.abilities = abilities
@export var input_controller: InputController:
    set(v):
        input_controller = v.duplicate(true)
        _config_updated()

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
    
    hitbox_controller.accepted_visitor.connect(accept)
    ability_controller.accepted_visitor.connect(accept)
    
    hitbox_controller.hit.connect(ability_controller.hit)
    health_controller.area2d.body_entered_once.connect(ability_controller.get_hit_by)
    #health_controller.damage_taken.connect(ability_controller.take_damage)
    
    _config_updated()

func _unhandled_input(event: InputEvent) -> void:
    if input_controller:
        input_controller.on_input_event(event)

func _config_updated():
    if not is_inside_tree():
        return
    if input_controller:
        _log.debug("input_controller controller configured")
        input_controller.use_paddle(self)
        input_controller.attack.connect(ability_controller.do_attack)
        input_controller.ability.connect(ability_controller.do_special)
    ability_controller.abilities = abilities
    ability_controller.do_passive()
