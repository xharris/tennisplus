extends AbilityControllerVisitor
class_name AbilityChangeCooldownSpeed

@export var scale: float = 1
## 0 it does not reset the scale change[br]
## else, the scale change is reset after given seconds
@export_range(0, INF, 0.1, "or_greater") var duration: float = 0

func visit_ability_controller(me: AbilityController):
    var old_scale = me.cooldown_speed_scale
    me.cooldown_speed_scale = scale
    if duration > 0:
        var timer = Timer.new()
        timer.one_shot = true
        timer.time_left = duration
        timer.autostart = true
        timer.timeout.connect(_on_timer_timeout.bind(me, timer, old_scale))
        me.add_child(timer)
        
func _on_timer_timeout(me: AbilityController, timer: Timer, old_scale: float):
    timer.queue_free()
    if me.cooldown_speed_scale == scale:
        # only reset if it hasn't been modified again
        me.cooldown_speed_scale = old_scale
