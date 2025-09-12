extends Node2D
class_name PlayerManager

var _log = Logger.new("player_manager")

func get_player1() -> Player:
    for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
        if p.index == 1:
            return p
    return null

## TODO add enum ArrangeType {Circle, QuarterCircleBottom}
func arrange_players():
    await get_tree().process_frame
    var view = get_viewport_rect()
    var view_center = view.get_center()
    var count = get_tree().get_node_count_in_group(Groups.PLAYER)
    var i = 0
    _log.info("player count: %d" % count)
    for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
        var angle = deg_to_rad(lerp(90, 90 + 360, i / count))
        var target_position = view_center + \
            (Vector2.from_angle(angle) * min(view.size.x, view.size.y) / 3)
        _log.info("move %s to %s" % [p, target_position])
        var t = p.create_tween()
        t.set_ease(Tween.EASE_OUT)
        t.set_trans(Tween.TRANS_BACK)
        t.tween_property(p, "global_position", target_position, 2)
        i += 1
