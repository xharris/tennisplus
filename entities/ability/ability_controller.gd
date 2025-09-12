extends Node
class_name AbilityController

signal accepted_visitor(v: Visitor)
signal activated(ability: Ability)

@export var abilities: Array[Ability]

var _log = Logger.new("ability_controller")
var _order: Order
var _current: Ability:
    set(v):
        _current = v
        if _current and _current.passive:
            activate()
var _activated_ability: Ability
var _hits_left: int = 0

func accept(v: Visitor):
    accepted_visitor.emit(v)

func next_ability():
    if not _order:
        _order = Order.new()
    _order.set_items(abilities)
    _activated_ability = null
    _current = _order.next()
    if _current:
        _log.debug("next: %s" % [_current.resource_path])

func activate():
    if _activated_ability:
        return
    if _current:
        _activated_ability = _current
        _hits_left = _current.ball_hits.rand()
        for v in _current.all_visitors():
            accept(v)
        
func hit(node: Node2D):
    if _activated_ability:
        if node is BallHitbox:
            for v in _activated_ability.on_hit_ball:
                node.accept(v)
            _hits_left -= 1
            # out of ability activations
            if _hits_left <= 0:
                next_ability()
