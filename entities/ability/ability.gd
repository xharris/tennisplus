extends Resource
class_name Ability

@export var name: String
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
@export var on_take_damage: Array[Visitor]
