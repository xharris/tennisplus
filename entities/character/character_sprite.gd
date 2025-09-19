extends Node2D
class_name CharacterSprite

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprites: Node2D = $Sprites
@onready var head: Sprite2D = %Head
@onready var body: Sprite2D = %Body
@onready var arm_l_offset: Node2D = $Sprites/ArmLOffset
@onready var arm_r_offset: Node2D = $Sprites/ArmROffset
@onready var arm_l: Node2D = $Sprites/ArmLOffset/ArmL
@onready var arm_r: Node2D = $Sprites/ArmROffset/ArmR
@onready var hand_l: Node2D = $Sprites/ArmLOffset/ArmL/HandL
@onready var hand_r: Node2D = $Sprites/ArmROffset/ArmR/HandR
@onready var hand_l_sprite: Sprite2D = $Sprites/ArmLOffset/ArmL/HandL/Hand
@onready var hand_r_sprite: Sprite2D = $Sprites/ArmROffset/ArmR/HandR/Hand
@onready var weapon_l: Node2D = $Sprites/ArmLOffset/ArmL/HandL/WeaponL

@export var config: CharacterConfig:
    set(v):
        config = v
        _config_updated()
@export var weapon_config: WeaponConfig:
    set(v):
        weapon_config = v
        _config_updated()
var weapon: Weapon

var _log = Logger.new("character_sprite")
var _global_position: Vector2
var weapon_animation_names: Array[StringName]

func _ready() -> void:
    _config_updated()
    _global_position = global_position

func _process(delta: float) -> void:
    _global_position = _global_position.lerp(global_position, delta * 18)
    arm_l_offset.global_position = _global_position
    arm_r_offset.global_position = _global_position
    var view = get_viewport_rect()
    if global_position.x < view.size.x / 2:
        sprites.scale.x = abs(sprites.scale.x)
    else:
        sprites.scale.x = -abs(sprites.scale.x)

func _config_updated():
    if not is_inside_tree():
        return
    # character config
    if config:
        arm_l.position = config.arm_position
        arm_r.position = config.arm_position * Vector2(-1, 1)
        hand_l.position.y = config.arm_length
        hand_r.position.y = config.arm_length
        if config.body_texture:
            set_body_texture(config.body_texture)
        if config.hand_texture:
            set_hand_texture(config.hand_texture)
    # weapon config
    if weapon_config:
        for child in weapon_l.get_children():
            weapon_l.remove_child(child)
            child.queue_free()
        if weapon_config.scene:
            var scene = weapon_config.scene.instantiate()
            if scene is not Weapon:
                _log.warn("weapon scene is not of type Weapon: %s" % [weapon_config.name])
            else:
                weapon = scene
                weapon_l.add_child(scene)
        if weapon and weapon_config.animations:
            animation_player.remove_animation_library("weapon")
            animation_player.add_animation_library("weapon", weapon_config.animations)
            weapon_animation_names = weapon_config.animations.get_animation_list()
            _log.info("weapon animations: %s" % weapon_animation_names)

func play_attack_animation():
    if animation_player.has_animation_library("weapon") and weapon_animation_names.size() > 0:
        animation_player.stop(true)
        animation_player.speed_scale = 2.0
        var animation_name = "weapon/%s" % weapon_animation_names.pick_random() as StringName
        var reverse = false
        if weapon_config and weapon_config.can_reverse_animation:
            reverse = [true, false].pick_random()
        if reverse:
            animation_player.play_backwards(animation_name)
        else:
            animation_player.play(animation_name)
        
func set_hand_texture(tex: Texture2D):
    hand_l_sprite.texture = tex
    hand_r_sprite.texture = tex
    
func set_body_texture(tex: Texture2D):
    head.texture = tex
    body.texture = tex
