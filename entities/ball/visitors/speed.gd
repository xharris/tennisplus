extends BallVisitor
class_name BallSpeed

enum Operation {Set}

@export var operation: Operation = Operation.Set
@export var speed_scale: float = 1.0

func visit_ball(me: Ball):
    _log.debug("speed: %s %f" % [Operation.find_key(operation), speed_scale])
    match operation:
        Operation.Set:
            me.physics.speed_scale = speed_scale
