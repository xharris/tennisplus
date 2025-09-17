extends Node

signal ball_created(ball: Ball)

func accept(v: Visitor):
    if v is BallManagerVisitor:
        v.visit_ball_manager(self)

func create_ball() -> Ball:
    var ball = Ball.SCENE.instantiate() as Ball
    ball.accepted_visitor.connect(accept)
    _add_ball.call_deferred(ball)
    return ball

func _add_ball(ball: Ball):
    add_child(ball)
    ball_created.emit(ball)
