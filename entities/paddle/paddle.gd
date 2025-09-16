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

func _ready() -> void:
    add_to_group(Groups.PADDLE)
    
    _connect_exports()
    _hitbox_controller.hit.connect(_ability_controller.hit)
    _hitbox_controller.accepted_visitor.connect(accept)
    _ability_controller.accepted_visitor.connect(accept)
    #_ability_controller.activated.connect(_on_ability_activated)
    _health_controller.body_entered.connect(_on_health_controller_body_entered)

    _ability_controller.abilities = abilities
    _ability_controller.next_ability()

func _on_health_controller_body_entered(body: Node2D):
    if body is BallHitbox:
        body.hit(_health_controller)

func _connect_exports():
    if not input:
        return
    input.attack.connect(_hitbox_controller.attack)
    input.ability.connect(_ability_controller.activate)
