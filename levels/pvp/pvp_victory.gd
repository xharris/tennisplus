extends Level
class_name PvpVictory

@export var on_any_input: Array[Visitor]

func _ready() -> void:
    var last_player = get_tree().get_first_node_in_group(Groups.PLAYER)
    if not last_player:
        _log.warn("no player")
        return exit()
    last_player.input.any_input.connect(_on_player_any_input)

func _on_player_any_input(_e: InputEvent):
    Visitor.visit_any(self, on_any_input)
