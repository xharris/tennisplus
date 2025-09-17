extends BallManagerVisitor
class_name BallInstanceCount

static var _log = Logger.new("ball_instance_count")#, Logger.Level.DEBUG)

enum Operation {Gte, Lte}

@export var operation: Operation = Operation.Gte
@export var count: int = 1

func visit_ball_manager(me: BallManager):
    var balls: Array[Ball]
    balls.assign(me.get_tree().get_nodes_in_group(Groups.BALL))
    var diff = abs(balls.size() - count)
    _log.debug("instances: %d, want: %d" % [balls.size(), count])
    
    match operation:
        # not enough balls
        Operation.Gte:
            if balls.size() >= count:
                return
            while diff > 0:
                _log.debug("add")
                me.create_ball()
                diff -= 1
            
        # too many balls
        Operation.Lte:
            if balls.size() <= count:
                return
            while diff > 0:
                _log.debug("remove")
                var ball: Ball = balls.pick_random()
                ball.destroy()
                diff -= 1
