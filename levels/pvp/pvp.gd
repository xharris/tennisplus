extends Level
class_name Pvp

func _ready() -> void:
    super._ready()
    visibility_changed.connect(_on_visibility_changed)
    
func _on_visibility_changed():
    if visible:
        pass
        # TODO create ball in center
        
