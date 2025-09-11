extends BallVisitor
class_name BallSpeed

@export var speed_scale: float = 1.0

func visit_ball(me: Ball):
    _log.debug("set speed: %f" % speed_scale)
    me.physics.speed_scale = speed_scale
