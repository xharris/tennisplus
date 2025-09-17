extends Node2D
class_name Level

static var SCENE = preload("res://entities/level/level.tscn")

signal accepted_visitor(v: Visitor)
signal exited(level: Level)

var config: LevelConfig:
    set(v):
        config = v
        if config and config.player_arrange_angles:
            _player_arrange_angles = config.player_arrange_angles
var _log = Logger.new("level", Logger.Level.DEBUG)
var _player_arrange_angles: RangeInt = RangeInt.new(0, 180)

func _ready() -> void:
    _log.set_id(config.name)
    PlayerManager.player_joined.connect(_on_player_joined)
    PlayerManager.player1_set.connect(_on_player1_set)
    BallManager.ball_created.connect(_on_ball_created)
    Visitor.visit_any(self, config.on_enter)
    
    var player1 = PlayerManager.get_player1()
    if player1:
        _log.debug("check player1")
        _on_player1_set(player1)

func _on_ball_created(ball: Ball):
    Visitor.visit_any(self, config.on_ball_created)
    Visitor.visit_any(ball, config.on_ball_created)

func _on_player1_set(player: Player):
    player.input.back.connect(_on_player_input_back)

func _on_player_input_back():
    Visitor.visit_any(self, config.on_back)
    
func _on_player_joined(player: Player):
    PlayerManager.arrange_players_circle(_player_arrange_angles)

func accept(v: Visitor):
    if v is LevelVisitor:
        v.visit_level(self)
    accepted_visitor.emit(v)

func exit(skip_signal = false):
    _log.info("exit")
    if not skip_signal:
        exited.emit(self)
    Visitor.visit_any(self, config.on_exit)
    var parent = get_parent()
    if parent:
        parent.remove_child(self)
    queue_free()
