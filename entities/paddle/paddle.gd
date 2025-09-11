extends Node2D
class_name Paddle

var _log = Logger.new("paddle")
@onready var _input: PaddleInput = $Input
@onready var _hitbox_controller: PaddleHitboxController = $HitboxContoller

func _ready() -> void:
    add_to_group(Groups.PADDLE)
    _input.swing_activated.connect(_on_input_swing_activated)

func _on_input_swing_activated():
    _hitbox_controller.swing()
