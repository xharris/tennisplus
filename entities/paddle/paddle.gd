extends Node2D
class_name Paddle

var _log = Logger.new("paddle")
@onready var _hitbox: PaddleHitbox = $Hitbox
@onready var _input: PaddleInput = $Input

@export var on_hit_ball: Array[BallVisitor]

func _ready() -> void:
    add_to_group(Groups.PADDLE)
    _input.swing_activated.connect(_on_input_swing_activated)
    
func _on_input_swing_activated():
    _log.debug("swing!")
    var collisions = _hitbox.get_collisions()
    for c in collisions:
        if c is BallHitbox:
            for v in on_hit_ball:
                c.accept(v)
            _log.debug("hit: ball hitbox")
