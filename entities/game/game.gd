extends Node2D
class_name Game

@onready var ball: Ball = $Ball
@onready var paddle_l: Paddle = $PaddleL

func _ready() -> void:
    Logger.set_global_level(Logger.Level.DEBUG)

    ball.physics.set_target(paddle_l)
