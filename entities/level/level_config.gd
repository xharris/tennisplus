extends Resource
class_name LevelConfig

@export var name: StringName
@export var players_required: RangeInt
## Must inherit Level
@export var scene: PackedScene
@export var on_enter: Array[Visitor]
@export var on_exit: Array[Visitor]
@export var on_ball_created: Array[Visitor]
@export var add_player_abilities: Array[Ability]
## Allow new local players to join
@export var allow_player_join: bool = false
@export var player_arrange_angles: RangeInt = RangeInt.new(0, 180)
@export var on_back: Array[Visitor]
