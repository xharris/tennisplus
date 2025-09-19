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
## not added to ability queue
@export var passive: bool = false
@export var attack_cooldown: float = 1.0
## [code]true[/code] if ability does not require activation
@export var activate_immediately: bool = true
@export var on_activate: Array[Visitor]
@export var use_activate_animation: bool = true
@export var on_hit_ball: Array[Visitor]
@export var on_hit_by_ball: Array[Visitor]
