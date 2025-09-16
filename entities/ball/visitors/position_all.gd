extends Visitor
class_name BallPositionAll

@export var x: RangeRatio
@export var y: RangeRatio

func visit():
    var view = SceneTreeUtil.get_viewport().get_visible_rect()
    for b: Ball in SceneTreeUtil.get_tree().get_nodes_in_group(Groups.BALL):
        b.global_position.x = x.rand_lerp(view.position.x, view.position.x + view.size.x)
        b.global_position.y = y.rand_lerp(view.position.y, view.position.y + view.size.y)
        
