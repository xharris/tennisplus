extends Node2D
class_name Game

@onready var ball: Ball = $Ball
@onready var paddle_l: Paddle = $PaddleLeft

func _ready() -> void:
    Logger.set_global_level(Constants.GLOBAL_LOG_LEVEL)

    ball.physics.set_target(paddle_l)
