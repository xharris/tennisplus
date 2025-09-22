extends LevelManagerVisitor
class_name LevelManagerSetLevel

static var _log = Logger.new("set_level")

@export_file("*.tres") var level_config

func visit_level_manager(me: LevelManager):
    var config = load(level_config)
    _log.error(config is not LevelConfig, "path is not LevelConfig: %s" % [level_config])
    me.enter(config as LevelConfig)
