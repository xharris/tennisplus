extends BallVisitor
class_name BallTarget

var _log = Logger.new("ball_target", Logger.Level.DEBUG)

@export var random_in_group: StringName
## allow targetting the same node
@export var allow_repeat_target: bool = false

func visit_ball(me: Ball):
    if not me.is_inside_tree():
        _log.debug("ball not in tree yet")
        return
    if random_in_group.is_empty():
        return _log.warn("random_in_group is empty")
    var targets: Array[Node2D]
    targets.assign(me.get_tree().get_nodes_in_group(random_in_group))
    var last_target = me.physics.get_last_target()
    if not allow_repeat_target:
        targets = targets.filter(func(t: Node2D): 
            return t != last_target)
    if targets.is_empty():
        _log.debug("no targets found")
        return
    var target: Node2D = targets.pick_random()
    if last_target and target:
        _log.warn_if(
            not allow_repeat_target and last_target == target,
            "illegal repeated target\n\tlast: %s (%d)\n\ttarget: %s (%d)" % [
                last_target, last_target.get_instance_id(), 
                target, target.get_instance_id()
            ]
        )
    me.physics.set_target(target)
