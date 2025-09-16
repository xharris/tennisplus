extends BallVisitor
class_name BallPosition

@export var x: RangeRatio
@export var y: RangeRatio

func visit_ball(me: Ball):
    _log.set_id("position")
    var view = SceneTreeUtil.get_viewport().get_visible_rect()
    me.global_position.x = x.rand_lerp(view.position.x, view.position.x + view.size.x)
    me.global_position.y = y.rand_lerp(view.position.y, view.position.y + view.size.y)
    _log.info("position %s %s" % [me, me.global_position])
