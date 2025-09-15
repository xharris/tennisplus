extends Node2D
class_name PracticeDummy

@onready var health: HealthController = $Health
@onready var ability_controller: AbilityController = $AbilityController
@onready var paddle: Paddle = $Paddle

func _ready() -> void:
    add_to_group(Groups.PRACTICE_DUMMY)
    paddle.name = "PracticeDummyPaddle"
