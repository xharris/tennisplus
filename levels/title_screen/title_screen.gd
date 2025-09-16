extends Node2D
class_name TitleScreen

static var SCENE = preload("res://levels/title_screen/title_screen.tscn")

static func create() -> TitleScreen:
    return SCENE.instantiate()

signal play_pressed
signal practice_pressed

@onready var play: Button = %Play
@onready var practice: Button = %Practice
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var _log = Logger.new("title")
@export var arrange_angles: RangeInt = RangeInt.new(180 + 45, 45)

func _ready() -> void:
    PlayerManager.player_joined.connect(_on_player_joined)
    play.pressed.connect(_on_play_pressed)
    practice.pressed.connect(_on_practice_pressed)
    _connect_player1.call_deferred()
    visibility_changed.connect(_on_visibility_changed)
    
    play.grab_focus()
    PlayerManager.arrange_players_circle(arrange_angles)
    _connect_player1()

func _on_visibility_changed():
    canvas_layer.visible = visible

func _on_player_joined(p: Player):
    PlayerManager.arrange_players_circle(arrange_angles)
    _connect_player1()

func _on_play_pressed():
    if _get_player_count() <= 1:
        return _log.info("not enough players to play")
    play_pressed.emit()

func _on_practice_pressed():
    if _get_player_count() <= 0:
        return _log.info("not enough players to practice")
    practice_pressed.emit()

func _get_player_count() -> int:
    return get_tree().get_node_count_in_group(Groups.PLAYER)

func _connect_player1():
    var player1 = PlayerManager.get_player1()
    if not player1:
        return _log.warn("missing player 1")
    _log.info("connected player 1")
    if not player1.input.attack.is_connected(_on_player1_input_attack):
        player1.input.attack.connect(_on_player1_input_attack)

func _on_player1_input_attack() -> void:
    var control = get_viewport().gui_get_focus_owner()
    if control is Button:
        control.button_pressed = true
        control.pressed.emit()
