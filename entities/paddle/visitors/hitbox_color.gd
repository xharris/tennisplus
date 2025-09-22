extends PaddleVisitor
class_name PaddleHitboxColor

var _log = Logger.new("paddle_hitbox_color", Logger.Level.DEBUG)
@export var use_character_color: bool = true
@export var color: Color

func visit_paddle(me: Paddle):
    if use_character_color:
        var parent = me.get_parent()
        while parent != null and parent is not Player:
            parent = parent.get_parent()
        if parent and parent is Player:
            parent = parent as Player
            var palette = parent.config.character.get_palette(parent.config.palette_index)
            if palette:
                color = palette.color    
        else:
            _log.warn("no player found: paddle=%s" % [me])
    # apply color to hitboxes
    if color:
        for h in me.hitbox_controller.get_hitboxes():
            h.color = color
            _log.debug("set paddle htibox=%s, color=%s" % [h, h.color.to_html()])
