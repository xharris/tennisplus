extends BallVisitor
class_name BallSpeed

var _log = Logger.new("ball_speed")
enum Operation {Set, Add, Sub}

@export var operation: Operation = Operation.Set
@export var speed_scale: float = 0.5

func visit_ball(me: Ball):
    _log.debug("speed: %s %f" % [Operation.find_key(operation), speed_scale])
    match operation:
        Operation.Set:
            me.physics.speed_scale = speed_scale
        Operation.Add:
            me.physics.speed_scale += speed_scale
        Operation.Sub:
            me.physics.speed_scale -= speed_scale           
