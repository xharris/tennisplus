extends Node2D
class_name Level

static var SCENE = preload("res://entities/level/level.tscn")

signal accepted_visitor(v: Visitor)
signal exited(level: Level)

var config: LevelConfig:
    set(v):
        config = v
        if config and config.player_arrange:
            _player_arrange = config.player_arrange
var _log = Logger.new("level") # , Logger.Level.DEBUG)
var _player_arrange: PlayerArrangeConfig

func _ready() -> void:
    _log.set_id(config.name)
    PlayerManager.player_joined.connect(_on_player_joined)
    PlayerManager.player1_set.connect(_on_player1_set)
    BallManager.ball_created.connect(_on_ball_created)
    
    PlayerManager.player_join_enabled = config.allow_player_join
    
    var player1 = PlayerManager.get_player1()
    if player1:
        _log.debug("check player1")
        _on_player1_set(player1)
    for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
        _on_player_joined(p)
    Visitor.visit_any(self, config.on_enter)
    if _player_arrange:
        await PlayerManager.arrange_players(_player_arrange)
    Visitor.visit_any(self, config.on_arrange_finished)

func _on_ball_created(ball: Ball):
    Visitor.visit_any(self, config.on_ball_created)
    Visitor.visit_any(ball, config.on_ball_created)

func _on_player_joined(player: Player, arrange: bool = true):
    Visitor.visit_any(self, config.on_add_player)
    Visitor.visit_any(player, config.on_add_player)
    for a in config.add_player_abilities:
        _log.debug("add ability to player: %s" % a.name)
        if not player.paddle.ability_controller.has_ability(a.name):
            player.paddle.ability_controller.abilities.append(a)
    player.paddle.health_controller.died.connect(_on_player_died)
    if arrange and _player_arrange:
        await PlayerManager.arrange_players(_player_arrange)

func _on_player_died():
    var players: Array[Player]
    players.assign(get_tree().get_nodes_in_group(Groups.PLAYER))
    players = players.filter(func(p: Player): return p.paddle.health_controller.is_alive())
    _log.info("%d player(s) left" % [players.size()])
    if players.size() <= 1:
        Visitor.visit_any(self, config.on_one_player_left)
    elif _player_arrange:
        await PlayerManager.arrange_players(_player_arrange)
        
func _on_player1_set(player: Player):
    player.input_controller.back.connect(_on_player_input_back)

func _on_player_input_back():
    Visitor.visit_any(self, config.on_back)

func accept(v: Visitor):
    if v is LevelVisitor:
        v.visit_level(self)
    if is_inside_tree():
        for p: Paddle in get_tree().get_nodes_in_group(Groups.PADDLE):
            p.accept(v)
    accepted_visitor.emit(v)

func exit(skip_signal = false):
    _log.info("exit")
    if not skip_signal:
        exited.emit(self)
    if config.remove_added_abilities_on_exit:
        for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
            for a in config.add_player_abilities:
                p.paddle.ability_controller.remove_ability_by_name(a.name)
    Visitor.visit_any(self, config.on_exit)
    var parent = get_parent()
    if parent:
        parent.remove_child(self)
    queue_free()
