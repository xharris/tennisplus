extends BallVisitor
class_name BallCurveDistance

@export var curve_distance: RangeInt

func visit_ball(me: Ball):
    me.physics.curve_distance = curve_distance
