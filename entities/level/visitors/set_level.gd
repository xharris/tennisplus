extends LevelManagerVisitor
class_name LevelManagerSetLevel

static var _log = Logger.new("set_level")

@export_file("*.tres") var level_config

func visit_level_manager(me: LevelManager):
    var config = load(level_config)
    if not config is LevelConfig:
        return _log.warn("path is not LevelConfig: %s" % [level_config])
    me.enter(config as LevelConfig)
