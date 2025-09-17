extends Node

signal ball_created(ball: Ball)

func accept(v: Visitor):
    if v is BallManagerVisitor:
        v.visit_ball_manager(self)

func create_ball() -> Ball:
    var ball = Ball.SCENE.instantiate() as Ball
    ball.accepted_visitor.connect(accept)
    add_child(ball)
    ball_created.emit(ball)
    return ball
