extends HealthVisitor
class_name HealthMax

enum Operation {Set}

@export var operation: Operation = Operation.Set
@export var value: int = 0

var _log = Logger.new("health_current")

func visit_health(me: HealthController):
    _log.debug("%s %d" % [Operation.find_key(operation), value])
    var _current = me._current
    match operation:
        Operation.Set:
            me._max = value
