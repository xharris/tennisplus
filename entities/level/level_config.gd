extends Resource
class_name LevelConfig

@export var name: StringName
@export var players_required: RangeInt
## Must inherit Level
@export var scene: PackedScene
@export var on_enter: Array[Visitor]
@export var on_exit: Array[Visitor]
## clear LevelManager's previous level config (will not return to previous level on exit)
@export var clear_prev_config: bool = false
## Disconnected after all [code]on_enter[/code] visitors are called
@export var on_ball_created: Array[Visitor]
## Also called for each existing player on level enter
@export var on_add_player: Array[Visitor]
@export var add_player_abilities: Array[Ability]
@export var remove_added_abilities_on_exit: Array[Ability]
## Allow new local players to join
@export var allow_player_join: bool = false
@export var player_arrange: PlayerArrangeConfig
@export var on_back: Array[Visitor]
@export var on_one_player_left: Array[Visitor]
