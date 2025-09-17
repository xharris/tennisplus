extends LevelVisitor
class_name LevelExit

func visit_level(me: Level):
    me.exit()
