extends BallVisitor
class_name BallTarget

@export var random_in_group: StringName
## allow targetting the same node
@export var allow_repeat_target: bool = false

func visit_ball(me: Ball):
    if random_in_group.is_empty():
        return _log.warn("random_in_group is empty")
    var targets: Array[Node2D]
    targets.assign(me.get_tree().get_nodes_in_group(random_in_group))
    if not allow_repeat_target:
        var last_target = me.physics.get_last_target()
        targets = targets.filter(func(t: Node2D): return t != last_target)
    if targets.is_empty():
        _log.info("no targets found")
        return
    var target: Node2D = targets.pick_random()
    me.physics.set_target(target)
