extends PlayerManagerVisitor
class_name IfSinglePlayer

var _log = Logger.new("if_single_player")
@export var then: Array[Visitor]

func visit_player_manager(me: PlayerManager):
    var count = me.get_tree().get_node_count_in_group(Groups.PLAYER)
    _log.info("player count: %d" % [count])
    if count == 1:
        _log.info("true, visitors=%d" % [then.size()])
        Visitor.visit_any(me, then)
    else:
        _log.info("false")
