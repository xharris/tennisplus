extends Visitor
class_name BallInstanceCount

@export var count: int = 1

func visit():
    var balls: Array[Ball]
    balls.assign(SceneTreeUtil.get_tree().get_nodes_in_group(Groups.BALL))
    var diff = balls.size() - count
    if diff == 0:
        return # no change
    var add = balls.size() < count
    diff = abs(diff)
    while diff > 0:
        if add:
            var ball = Ball.create()
        else:
            var ball: Ball = balls.pick_random()
            ball.queue_free()
