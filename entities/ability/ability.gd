extends Resource
class_name Ability

## number of ball hits until ability ends (including activation hit)[br]
## [br]
## default: [1, 1]
@export var ball_hits: RangeInt:
    get:
        if ball_hits == null:
            return Constants.ABILITY_BALL_HITS
        return ball_hits
## [code]true[/code] if ability does not require activation
@export var passive: bool = true
@export var on_activate: Array[Visitor]
@export var on_hit_ball: Array[Visitor]

func all_visitors() -> Array[Visitor]:
    var out: Array[Visitor]
    out.append_array(on_activate)
    out.append_array(on_hit_ball)
    return out
