extends Node2D
class_name Player

static var SCENE = preload("res://entities/player/player.tscn")
static var _player_count = 0

## NOTE automatically added to Game node
static func create() -> Player:
    var me = SCENE.instantiate() as Player
    return me

@onready var paddle: Paddle = $Paddle
@onready var sprite: CharacterSprite = $CharacterSprite

var input_controller: InputController:
    set(v):
        paddle.input_controller = v
    get:
        return paddle.input_controller
@export var config: PlayerConfig:
    set(v):
        config = v
        _config_updated()

## player 1, player 2, etc
## TODO remove and use index in group?
var index = 0

func _init() -> void:
    _player_count += 1
    index = _player_count
    
func _config_updated():
    if not (config and is_inside_tree()):
        return
    sprite.config = config.character
    paddle.input_controller = config.input_controller
    if paddle.input_controller is PlayerInput:
        paddle.input_controller.config = config.input

func _process(delta: float) -> void:
    sprite.animation_player.speed_scale = paddle.ability_controller.cooldown_speed_scale

func _ready() -> void:
    add_to_group(Groups.PLAYER)
    set_log_prefix("player%d" % index)
    _config_updated()
    
    paddle.health_controller.died.connect(_on_died)
    paddle.ability_controller.attack_activated.connect(_on_attack_activated)
    sprite.weapon.attack_window_entered.connect(_on_weapon_attack_window_entered)
    sprite.weapon.attack_window_exited.connect(_on_weapon_attack_window_exited)
    sprite.animation_player.animation_finished.connect(_on_sprite_animation_finished)

func _on_sprite_animation_finished(_name: StringName):
    sprite.weapon.attack_end()

func _on_weapon_attack_window_entered():
    paddle.hitbox_controller.enabled = true

func _on_weapon_attack_window_exited():
    paddle.hitbox_controller.enabled = false
    
func _on_attack_activated(_a: Ability):
    sprite.play_attack_animation()

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
