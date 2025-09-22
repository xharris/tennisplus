extends Node2D

signal player_joined(p: Player)
signal player1_set(p: Player)

var DEFAULT_PLAYER_CONFIG: PlayerConfig = preload("res://resources/player_configs/default.tres")

var player_configs: Array[PlayerConfig] = [
    preload("res://resources/player_configs/toast.tres")
]

## TODO replace with player_settings_configs when settings are saved/loaded
var player_input_configs: Array[PlayerInputConfig] = [
    preload("res://resources/player_input_configs/player1_key.tres"),
    preload("res://resources/player_input_configs/player2_key.tres")
]

var _log = Logger.new("player_manager")#, Logger.Level.DEBUG)
var _player1: Player
## enable new players to join
var player_join_enabled: bool = true

func accept(v: Visitor):
    if v is PlayerManagerVisitor:
        v.visit_player_manager(self)

func _unhandled_input(event: InputEvent) -> void:
    if not player_join_enabled:
        return
    for input_config in player_input_configs:
        # check if player already exists
        var skip = false
        for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
            var input: InputController = p.input_controller
            if input is PlayerInput and input.config and input.config.name == input_config.name:
                skip = true
                break
        if skip:
            continue
        # is a player trying to join?
        if input_config.is_pressed(event, input_config.attack):
            var config: PlayerConfig = DEFAULT_PLAYER_CONFIG.duplicate(true)
            for c2: PlayerConfig in player_configs:
                if c2.input and c2.input.attack.is_match(event):
                    config = c2.duplicate(true)
            if not config.input:
                config.input = input_config
            var new_player = add_player(config)

func add_player(config: PlayerConfig) -> Player:
    var view = get_viewport_rect()
    # add new player
    var new_player = Player.create()
    new_player.config = config
    _log.info("add player, config=%s" % [new_player.config.name])
    # move player to top middle off-screen
    new_player.global_position.x = view.size.x / 2
    new_player.global_position.y = view.position.y - 120
    new_player.name = config.name
    add_child(new_player)
    player_joined.emit(new_player)
    # is this a new player1?
    if not _player1:
        _player1 = new_player
        player1_set.emit(_player1)
    return new_player

func get_player1() -> Player:
    return _player1

## TODO add enum ArrangeType {Circle, QuarterCircleBottom}
func arrange_players(config: PlayerArrangeConfig):
    await get_tree().process_frame
    var view = get_viewport_rect()
    var view_center = view.get_center()
    var radius = max(0, min(view.size.x, view.size.y) * config.radius - 30)
    var count = get_tree().get_node_count_in_group(Groups.PLAYER)
    var i: float = 0
    _log.info("arrange %d" % [count])
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
