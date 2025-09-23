extends Node2D
class_name BallTarget

signal targetted(ball: Ball)

func _ready() -> void:
    add_to_group(Groups.BALL_TARGET)
    BallManager.ball_created.connect(_on_ball_created)
    
func _on_ball_created(ball: Ball):
    ball.physics.target_set.connect(_on_ball_target_set.bind(ball))
    
func _on_ball_target_set(target: BallTarget, ball: Ball):
    if target == self:
        targetted.emit(ball)
