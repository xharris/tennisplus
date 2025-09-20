extends PlayerManagerVisitor
class_name AddPlayer

@export var config: PlayerConfig

func visit_player_manager(me: PlayerManager):
    me.add_player(config)
