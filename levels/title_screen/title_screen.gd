extends Level
class_name TitleScreen

@onready var play: Button = %Play
@onready var practice: Button = %Practice
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@export var arrange_angles: RangeInt = RangeInt.new(180 + 45, 45)
@export var on_play_pressed: Array[Visitor]
@export var on_practice_pressed: Array[Visitor]

func _ready() -> void:
    super._ready()
    if not PlayerManager.player1_set.is_connected(_on_player1_set):
        PlayerManager.player1_set.connect(_on_player1_set)
    play.pressed.connect(_on_play_pressed)
    practice.pressed.connect(_on_practice_pressed)
    
    play.grab_focus()

func _on_player1_set(player: Player):
    _log.info("connected player 1")
    if not player.input_controller.attack.is_connected(_on_player1_input_attack):
        player.input_controller.attack.connect(_on_player1_input_attack)

func _on_play_pressed():
    Visitor.visit_any(self, on_play_pressed)

func _on_practice_pressed():
    Visitor.visit_any(self, on_practice_pressed)

func _on_player1_input_attack() -> void:
    var control = get_viewport().gui_get_focus_owner()
    if control is Button:
        control.button_pressed = true
        control.pressed.emit()
