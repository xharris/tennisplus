extends Node2D
class_name TitleScreen

signal play_pressed

@onready var play: Button = %Play
@onready var practice: Button = %Practice
@onready var player_manager: PlayerManager = $PlayerManager

var _log = Logger.new("title")
@export var player1: Player

func _ready() -> void:
    play.pressed.connect(play_pressed.emit)
    _connect_player1.call_deferred()
    
    var view = get_viewport_rect()
    play.grab_focus()
    # move player to top middle off-screen
    player1.global_position.x = view.size.x / 2
    player1.global_position.y = view.position.y - 120
    player_manager.arrange_players()

func _connect_player1():
    var player1 = player_manager.get_player1()
    if not player1:
        return _log.warn("missing player 1")
    player1.input.attack.connect(_on_player1_input_attack)

func _on_player1_input_attack() -> void:
    var control = get_viewport().gui_get_focus_owner()
    if control is Button:
        control.button_pressed = true
        control.pressed.emit()
