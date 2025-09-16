extends Node

signal ball_created(ball: Ball)

func create_ball() -> Ball:
    var ball = Ball.SCENE.instantiate() as Ball
    add_child(ball)
    ball_created.emit(ball)
    return ball
