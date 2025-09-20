extends Node2D
class_name Player

static var SCENE = preload("res://entities/player/player.tscn")
static var _player_count = 0

## NOTE automatically added to Game node
static func create() -> Player:
    var me = SCENE.instantiate() as Player
    return me

@onready var paddle: Paddle = $Paddle
@onready var input: PlayerInput = $PlayerInput
@onready var sprite: CharacterSprite = $CharacterSprite

@export var config: PlayerConfig:
    set(v):
        config = v
        _config_updated()

## player 1, player 2, etc
var index = 0

func _init() -> void:
    _player_count += 1
    index = _player_count
    
func _config_updated():
    if not (config and is_inside_tree()):
        return
    input.config = config.input
    sprite.config = config.character

func _ready() -> void:
    add_to_group(Groups.PLAYER)
    set_log_prefix("player%d" % index)
    _config_updated()
    
    paddle.health_controller.died.connect(_on_died)
    paddle.ability_controller.activated.connect(_on_ability_activated)
    sprite.weapon.attacked.connect(paddle.hitbox_controller.attack)
    input.attack.connect(_on_input_attack)

func _on_input_attack():
    if paddle.hitbox_controller.enabled:
        sprite.play_attack_animation()

func _on_ability_activated(a: Ability):
    paddle.hitbox_controller.cooldown = a.attack_cooldown

func _on_died():
    destroy()

func _exit_tree() -> void:
    _player_count -= 1

func set_log_prefix(prefix: String):
    paddle.set_log_prefix(prefix)
    
func destroy():
    var parent = get_parent()
    if parent:
        parent.remove_child(self)
    queue_free()
