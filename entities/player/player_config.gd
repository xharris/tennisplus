extends Resource
class_name PlayerConfig

static var PLAYER_INPUT_CONTROLLER: InputController = preload("res://resources/input_controllers/player_input.tres")

@export var name: StringName
@export var input: PlayerInputConfig
@export var input_controller: InputController = PLAYER_INPUT_CONTROLLER:
    set(v):
        if v:
            input_controller = v.duplicate(true)
        else:
            input_controller = v
@export var device: int # TODO how does this work?
@export var character: CharacterConfig
@export var palette_index: int
@export var weapon: WeaponConfig
