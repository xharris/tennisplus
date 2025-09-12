extends Node2D
class_name TitleScreen

signal play_pressed

@onready var play: Button = %Play
@onready var practice: Button = %Practice
@onready var player_manager: PlayerManager = $PlayerManager

var _log = Logger.new("title")
@export var arrange_angles: RangeInt = RangeInt.new(180 + 45, 45)

func _ready() -> void:
    play.pressed.connect(play_pressed.emit)
    player_manager.player_join_requested.connect(_on_player_join_requested)
    _connect_player1.call_deferred()
    
    play.grab_focus()
    player_manager.arrange_players_circle(arrange_angles)

func _on_player_join_requested(input_config: PlayerInputConfig):
    _log.info("player join requested: %s" % [input_config.name])
    var view = get_viewport_rect()
    # add new player
    var new_player = Player.create()
    new_player.input_config = input_config
    # move player to top middle off-screen
    new_player.global_position.x = view.size.x / 2
    new_player.global_position.y = view.position.y - 120
    new_player.name = input_config.name
    add_child(new_player)
    _connect_player1()
    player_manager.arrange_players_circle(arrange_angles)

func _connect_player1():
    var player1 = player_manager.get_player1()
    if not player1:
        return _log.warn("missing player 1")
    if not player1.input.attack.is_connected(_on_player1_input_attack):
        player1.input.attack.connect(_on_player1_input_attack)

func _on_player1_input_attack() -> void:
    var control = get_viewport().gui_get_focus_owner()
    if control is Button:
        control.button_pressed = true
        control.pressed.emit()
