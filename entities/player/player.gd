extends Node2D
class_name Player

static var SCENE = preload("res://entities/player/player.tscn")
static var _player_count = 0

## NOTE automatically added to Game node
static func create() -> Player:
    var me = SCENE.instantiate() as Player
    return me

var _log = Logger.new("player")

@onready var sprite: CharacterSprite = $CharacterSprite
@onready var hitbox_controller: PaddleHitboxController = $PaddleHitboxContoller
@onready var ability_controller: AbilityController = $AbilityController
@onready var health_controller: HealthController = $Health
@onready var ball_target: BallTarget = $BallTarget

@export var input_controller: InputController
@export var config: PlayerConfig:
    set(v):
        config = v
        _config_updated()

## player 1, player 2, etc
## TODO remove and use index in group?
var index = 0

func accept(v: Visitor):
    if v is PaddleVisitor:
        v.visit_paddle_hitbox_controller(hitbox_controller)
    elif v is AbilityControllerVisitor:
        v.visit_ability_controller(ability_controller)
    elif v is HealthVisitor:
        v.visit_health(health_controller)

func _init() -> void:
    _player_count += 1
    index = _player_count

func _process(delta: float) -> void:
    sprite.animation_player.speed_scale = 1 # ability_controller.cooldown_speed_scale

func _ready() -> void:
    add_to_group(Groups.PLAYER)
    set_log_prefix("player%d" % index)
    _config_updated()
    
    health_controller.area2d.body_entered_once.connect(ability_controller.get_hit_by)
    health_controller.died.connect(_on_died)
    #health_controller.damage_taken.connect(ability_controller.take_damage)
    hitbox_controller.hit.connect(_on_hitbox_hit)
    ability_controller.attack_activated.connect(_on_attack_activated)
    sprite.weapon.attack_window_entered.connect(_on_weapon_attack_window_entered)
    sprite.weapon.attack_window_exited.connect(_on_weapon_attack_window_exited)
    sprite.weapon.attack_started.connect(sprite.play_attack_animation)
    sprite.animation_player.animation_finished.connect(_on_sprite_animation_finished)
    input_controller.attack.connect(sprite.weapon.attack)
    ball_target.targetted.connect(_on_ball_target_targetted)

    hitbox_controller.accepted_visitor.connect(accept)
    ability_controller.accepted_visitor.connect(accept)
    sprite.accepted_visitor.connect(accept)
    
    ability_controller.abilities = config.weapon.abilities
    
func _on_ball_target_targetted(ball: Ball):
    for h in hitbox_controller.get_hitboxes():
        h.add_indicator_node(ball)
    
func _on_hitbox_hit(node: Node2D):
    ability_controller.hit(node)
    
    for h in hitbox_controller.get_hitboxes():
        h.remove_indicator_node(node)
    
func _on_sprite_animation_finished(_name: StringName):
    sprite.weapon.attack_end()

func _on_weapon_attack_window_entered():
    hitbox_controller.enabled = true

func _on_weapon_attack_window_exited():
    hitbox_controller.enabled = false
    
func _on_attack_activated(_a: Ability):
    sprite.play_attack_animation()

func _on_died():
    destroy()

func _exit_tree() -> void:
    _player_count -= 1

func set_log_prefix(prefix: String):
    _log.set_prefix(prefix)
    
func destroy():
    var parent = get_parent()
    if parent:
        parent.remove_child(self)
    queue_free()
    _config_updated()

func _unhandled_input(event: InputEvent) -> void:
    if input_controller:
        input_controller.on_input_event(event)

func _config_updated():
    if not (config and is_inside_tree()):
        return
    sprite.config = config.character
    input_controller = config.input_controller
    input_controller.use_paddle_hitbox_controller(self.hitbox_controller)
    if input_controller is PlayerInput:
        input_controller.config = config.input
        
    if input_controller:
        _log.debug("input_controller controller configured")
        input_controller.ability.connect(ability_controller.activate)
