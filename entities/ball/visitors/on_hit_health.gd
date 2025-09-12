extends BallVisitor
class_name BallOnHitHealth

@export var visitors: Array[Visitor]

func visit_ball(me: Ball) -> void:
    me.hitbox.on_hit.assign(visitors)
