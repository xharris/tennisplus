extends BallVisitor
class_name BallTarget

@export var random_in_group: StringName

func visit_ball(me: Ball):
    if not random_in_group.is_empty():
        var targets: Array[Node2D]
        targets.assign(me.get_tree().get_nodes_in_group(random_in_group))
        targets = targets.filter(func(t: Node2D): return t != me.physics.get_target())
        if targets.is_empty():
            _log.debug("no targets found")
            return
        var target: Node2D = targets.pick_random()
        me.physics.set_target(target)
