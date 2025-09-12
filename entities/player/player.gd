extends Node2D
class_name Player

static var SCENE = preload("res://entities/player/player.tscn")
static var _player_count = 0

static func create() -> Player:
    var me = SCENE.instantiate() as Player
    return me
    
@onready var paddle: Paddle = $Paddle
@onready var input: PlayerInput = $PlayerInput

@export var input_config: PlayerInputConfig:
    set(v):
        input_config = v
        if input:
            input.config = input_config

## player 1, player 2, etc
var index = 0

func _init() -> void:
    _player_count += 1
    index = _player_count

func _ready() -> void:
    add_to_group(Groups.PLAYER)
    input.config = input_config

func _exit_tree() -> void:
    _player_count -= 1
