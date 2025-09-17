extends Node2D

signal player_joined(p: Player)
signal player1_set(p: Player)

## TODO replace with player_settings_configs when settings are saved/loaded
var player_input_configs: Array[PlayerInputConfig] = [
    preload("res://resources/player_input_configs/player1_key.tres"),
    preload("res://resources/player_input_configs/player2_key.tres")
]

var _log = Logger.new("player_manager")#, Logger.Level.DEBUG)
var _player1: Player

func _unhandled_input(event: InputEvent) -> void:
    for c in player_input_configs:
        # check if player already exists
        var skip = false
        for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
            if p.input.config.name == c.name:
                skip = true
                break
        if skip:
            continue
        # is a player trying to join?
        if c.is_pressed(event, c.attack):
            _log.info("player wants to join: %s" % [c.name])
            var view = get_viewport_rect()
            # add new player
            var new_player = Player.create()
            new_player.input_config = c
            # move player to top middle off-screen
            new_player.global_position.x = view.size.x / 2
            new_player.global_position.y = view.position.y - 120
            new_player.name = c.name
            add_child(new_player)
            player_joined.emit(new_player)
            # is this a new player1?
            if not _player1:
                _player1 = new_player
                player1_set.emit(_player1)

func get_player1() -> Player:
    return _player1

## TODO add enum ArrangeType {Circle, QuarterCircleBottom}
func arrange_players(config: PlayerArrangeConfig):
    await get_tree().process_frame
    var view = get_viewport_rect()
    var view_center = view.get_center()
    var radius = min(view.size.x, view.size.y) * config.radius
    var count = get_tree().get_node_count_in_group(Groups.PLAYER)
    var i: float = 0
    _log.debug("count: %d, i start: %d" % [count, i])
    var signals: Array[Signal]
    for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
        var weight = 0.5
        if count > 1 and not config.exclude_max:
            weight = i / (count - 1) 
        elif count > 1 and config.exclude_max:
            weight = i / count
        var angle = deg_to_rad(
            lerp(
                config.angle_range.get_min(), 
                config.angle_range.get_max(), 
                weight
            )
        )
        var target_position = view_center + Vector2.from_angle(angle) * radius
        _log.debug("angle_range=[%d, %d]" % config.angle_range.values())
        _log.debug("move %s, weight=%f angle=%d position=%s" % [p, weight, rad_to_deg(angle), target_position])
        var t = p.create_tween()
        t.set_ease(Tween.EASE_OUT)
        t.set_trans(Tween.TRANS_BACK)
        t.tween_property(p, "global_position", target_position, 2)
        signals.append(t.finished)
        i += 1
    await Async.all(signals)
