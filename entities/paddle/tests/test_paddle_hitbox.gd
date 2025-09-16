extends GutTest

## Verifies that a PaddleHitbox with `auto_hit = true` applies its `on_hit_ball` visitors

func test_auto_hit_visits_on_enter():
    # load the hitbox scene that sets auto_hit = true and has a visitor resource
    var scene = load("res://resources/abilities/practice_dummy/practice_dummy_hitbox.tscn")
    var hitbox_root = scene.instantiate()
    add_child(hitbox_root)

    # create a dummy ball node with an accept method so Visitor.visit_any can call it
    var helper_scene = load("res://entities/paddle/tests/test_helpers.gd")
    var ball = helper_scene.new()
    add_child(ball)

    # Simulate body entered: Area2DEnterOnce should emit body_entered_once once
    # Find the Area2DEnterOnce node inside the hitbox scene
    var area = hitbox_root.get_node("Hitbox")
    assert_not_null(area, "Hitbox area loaded")

    # Directly call the internal handler to simulate the physics signal (simpler than full physics)
    area._on_body_entered_once(ball)

    # on_hit_ball visitor should have been applied and recorded
    assert_true(ball.visited.size() > 0, "Visitor was applied on auto hit")
