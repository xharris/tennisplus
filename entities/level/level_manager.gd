extends Node2D

signal accepted_visitor(v: Visitor)

var _log = Logger.new("level_manager")#, Logger.Level.DEBUG)
var _prev_config: LevelConfig
var _current_config: LevelConfig

func accept(v: Visitor):
    if v is LevelManagerVisitor:
        v.visit_level_manager(self)
    accepted_visitor.emit(v)

func enter(config: LevelConfig):
    _log.info("enter %s" % config.name)
    if config.players_required:
        var player_count = get_tree().get_node_count_in_group(Groups.PLAYER)
        if config.players_required.get_min() > 0 and player_count < config.players_required.get_min():
            _log.warn("not enough players to enter")
            return
        if config.players_required.get_max() > 0 and player_count > config.players_required.get_max():
            _log.warn("too many players to enter")
            return
    # clear previous level
    for c in get_children():
        if c is Level:
            _prev_config = c.config
            c.exit(true)
    # enter level
    var level: Level
    _current_config = config
    if config.scene:
        _log.debug("use packed scene")
        level = config.scene.instantiate() as Level
    if not config.scene or not level:
        _log.debug("create empty scene")
        level = Level.SCENE.instantiate() as Level
    level.config = config
    level.accepted_visitor.connect(accept)
    var connect_result = level.connect("exited", Callable(self, "_on_exit_level"))
    _log.debug("level.exited connect result: %s for level=%s id=%d" % [connect_result, config.name, level.get_instance_id()])
    add_child(level)
    
func _on_exit_level(level: Level):
    _log.debug("_on_exit_level called for %s" % [level])
    if level.config.clear_prev_config:
        _prev_config = null
    elif _prev_config:
        enter(_prev_config)
