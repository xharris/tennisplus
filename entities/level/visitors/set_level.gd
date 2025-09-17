extends LevelManagerVisitor
class_name LevelManagerSetLevel

@export var level_config: LevelConfig

func visit_level_manager(me: LevelManager):
    me.enter(level_config)
