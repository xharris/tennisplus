## should only contain one collision shape
extends Area2DEnterOnce
class_name PaddleHitbox

signal accepted_visitor(v: Visitor)

var _log = Logger.new("paddle_hitbox")#, Logger.Level.DEBUG)
@onready var indicator: Node2D = %Indicator
@onready var circle_particles: GPUParticles2D = %CircleParticles
@export var on_hit_ball: Array[Visitor]
## [code]true[/code]: will not trigger overlapping PaddleHitbox[br]
## nodes higher in the tree will hit the ball first
@export var stop_propagation: bool = true
## will auto-hit any body that enters
@export var auto_hit: bool
## show indicator for these nodes
var _indicator_nodes: Array[Node2D]
var shape_size: float = 0
@export var color: Color = Color.hex(0xBDBDBDFF):
    set(v):
        color = v
        _config_updated()

func accept(v: Visitor):
    accepted_visitor.emit(v)

func _process(delta: float) -> void:
    _indicator_nodes = _indicator_nodes.filter(SceneTreeUtil.is_valid_node)
    if _indicator_nodes.is_empty():
        indicator.hide()
        circle_particles.amount_ratio = 0
    else:
        indicator.show()
        var dist: float = INF
        var _closest_node: Node2D
        for node in _indicator_nodes:
            var dist2: float = global_position.distance_to(node.global_position)
            if not _closest_node or dist2 < dist:
                _closest_node = node
                dist = dist2
        var max_dist = Constants.PADDLE_HITBOX_INDICATOR_DISTANCE
        var shape_dist = dist - shape_size
        if shape_dist > 0 and shape_dist < max_dist:
            var weight = lerpf(1, 0, clampi(shape_dist / max_dist, 0, max_dist))
            circle_particles.amount_ratio = lerpf(0.5, 1, shape_dist / max_dist)
        else:
            circle_particles.amount_ratio = 0
    if Engine.is_editor_hint():
        circle_particles.amount_ratio = 1

func _ready() -> void:
    super._ready()
    add_to_group(Groups.PADDLE_HITBOX)
    
    indicator.hide()
    circle_particles.amount_ratio = 0

    child_entered_tree.connect(_on_child_entered)
    body_entered_once.connect(_on_body_entered_once)
    
    _config_updated()

func _on_child_entered(node: Node2D):
    if not node.tree_exited.is_connected(_config_updated):
        node.tree_exited.connect(_config_updated)
    _config_updated()

func _on_body_entered_once(body: Node2D):
    _log.debug("entered: %s" % body)
    if auto_hit:
        _log.debug("auto hit")
        hit(body)

func hit(element: Node2D):
    Visitor.visit_any(element, on_hit_ball)

## show the indicator when the given node gets close
func add_indicator_node(node: Node2D):
    if not _indicator_nodes.has(node):
        _indicator_nodes.append(node)
    
func remove_indicator_node(node: Node2D):
    _indicator_nodes = _indicator_nodes.filter(func(n): return n != node)

func _config_updated():
    if not is_inside_tree():
        return
    var collision_shape: CollisionShape2D = find_child("CollisionShape2D")
    if not collision_shape:
        circle_particles.amount_ratio = 0
    else:
        var shape = collision_shape.shape
        var texture_size: float = 1

        if shape is CircleShape2D:
            shape_size = shape.radius
            _log.debug("found CircleShape2D: %d" % [shape_size])
            var mat: ParticleProcessMaterial = circle_particles.process_material
            if mat:
                mat = mat.duplicate(true)
                mat["color"] = color
                mat["emission_ring_radius"] = shape_size
                mat["emission_ring_inner_radius"] = shape_size
                circle_particles.process_material = mat
            else:
                _log.warn("no circle particle material: %s" % [circle_particles.material])
        else:
            _log.warn("unsupported indicator: %s" % [shape.get_class()])
            
            
