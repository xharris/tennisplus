extends HealthVisitor
class_name HealthCurrent

enum Operation {Sub}

@export var operation: Operation = Operation.Sub
@export var value: int = 0

var _log = Logger.new("health_current")

func visit_health(me: HealthController):
    _log.debug("%s %d" % [Operation.find_key(operation), value])
    match operation:
        Operation.Sub:
            me._current -= value
