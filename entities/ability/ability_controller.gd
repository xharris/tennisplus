extends Node
class_name AbilityController

signal accepted_visitor(v: Visitor)
signal activated(ability: Ability)

@export var abilities: Array[Ability]

var _log = Logger.new("ability_controller")#, Logger.Level.DEBUG)
var _order: Order
var _current: Ability:
    set(v):
        _current = v
        if _current and _current.activate_immediately:
            activate()
var _activated_ability: Ability
var _hits_left: int = 0

func accept(v: Visitor):
    accepted_visitor.emit(v)

func set_log_prefix(prefix: String):
    _log.set_prefix(prefix)

func _get_passive_abilities() -> Array[Ability]:
    return abilities.filter(func(a:Ability): return a.passive)

func next_ability():
    if not _order:
        _order = Order.new()
    var items = abilities.filter(func(a:Ability): return not a.passive)
    _log.debug("abilities: %s" % [abilities.map(func(a: Ability): return a.name)])
    _log.debug("abilities: %d, non-passive: %d" % [abilities.size(), items.size()])
    _order.set_items(items)
    _activated_ability = null
    _current = _order.next()
    if _current:
        _log.debug("next: %s" % [_current.name])

func activate():
    if _activated_ability:
        return
    if _current:
        _activated_ability = _current
    if not _activated_ability:
        return
    _log.info("activate: %s" % _activated_ability.name)
    _hits_left = _activated_ability.ball_hits.rand()
    Visitor.visit_any(null, _activated_ability.on_activate)
    Visitor.emit_accepted(accepted_visitor, _activated_ability.on_activate)
    activated.emit(_activated_ability)

func hit(element: Node):
    if element is BallHitbox:
        for a in _get_passive_abilities():
            _log.debug("hit ball: %s" % a.name)
            Visitor.visit_any(element, a.on_hit_ball)
        if _activated_ability:
            _log.debug("hit ball: %s" % _activated_ability.name)
            Visitor.visit_any(element, _activated_ability.on_hit_ball)
            _hits_left -= 1
            # out of ability activations
            if _hits_left <= 0:
                next_ability()

func hit_by(element: Node):
    if element is BallHitbox:
        element.hit(self)
        for a in _get_passive_abilities():
            _log.debug("hit by ball: %s" % a.name)
            Visitor.visit_any(element, a.on_hit_by_ball)
        if _activated_ability:
            _log.debug("hit by ball: %s" % _activated_ability.name)
            Visitor.visit_any(element, _activated_ability.on_hit_by_ball)

## NOTE not needed yet
func take_damage(_amount: int):
    pass

func has_ability(ability_name: String) -> bool:
    for a: Ability in abilities:
        if a.name == ability_name:
            return true
    return false
    
func remove_ability_by_name(ability_name: String):
    abilities = abilities.filter(func(a: Ability):
        return a.name != ability_name)
