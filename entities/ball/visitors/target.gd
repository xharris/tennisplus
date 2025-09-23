extends BallVisitor
class_name BallTargetVisitor

var _log = Logger.new("ball_target", Logger.Level.DEBUG)

## allow targetting the same node
@export var allow_repeat_target: bool = false

func visit_ball(me: Ball):
    if not me.is_inside_tree():
        _log.debug("ball not in tree yet")
        return
    var targets: Array[BallTarget]
    targets.assign(me.get_tree().get_nodes_in_group(Groups.BALL_TARGET))
    var last_target = me.physics.get_last_target()
    if not allow_repeat_target:
        targets = targets.filter(func(t: BallTarget): 
            return t != last_target)
    if targets.is_empty():
        _log.debug("no targets found")
        return
    var target: BallTarget = targets.pick_random()
    if last_target and target:
        _log.warn_if(
            not allow_repeat_target and last_target == target,
            "illegal repeated target\n\tlast: %s (%d)\n\ttarget: %s (%d)" % [
                last_target, last_target.get_instance_id(), 
                target, target.get_instance_id()
            ]
        )
    me.physics.set_target(target)
