<!-- Copilot instructions for the Tennis+ Godot project -->

# Quick context

Tennis+ is a Godot 4.x project (mobile rendering target) that uses scene-based architecture, central autoload singletons, and the GUT test framework (bundled under `addons/gut`). AI agents should treat this repo as a Godot game codebase, not a typical web/service app.

# Big-picture architecture (what matters)

- **Scenes & Nodes:** gameplay pieces are Scenes with scripts. Look for `class_name` declarations (e.g. `Practice`, `PracticeDummy`, `PlayerManager`) and `*.tscn` files to find entry points.
- **Autoload singletons:** defined in `project.godot`. Important singletons:
  - `Events` -> `res://resources/events.gd` (signal hub)
  - `PlayerManager` -> `res://entities/player/player_manager.gd` (player lifecycle)
  - `SceneTreeUtil` -> `res://resources/scene_tree_util.gd` (tree helpers)
- **Groups:** entities are organized via Godot groups (examples: `Groups.PLAYER`, `Groups.BALL`, `Groups.PRACTICE_DUMMY`). Code often iterates group nodes (use `get_tree().get_nodes_in_group(...)`). See `levels/practice/practice.gd` for a representative pattern.
- **Visitor pattern:** `Visitor.visit_any(...)` is used to apply behavior to nodes (see `levels/practice/practice.gd` and `entities/ball/visitors/*`).
- **Logging:** project uses a simple `Logger` wrapper widely (e.g. `Logger.new("practice")`). Search `Logger.new` to find examples.

# Project workflows (how to run, test, debug)

- Open the project in Godot 4.x using `project.godot`. The main scenes live under `game/` and `levels/`.
- Tests: this repo includes the GUT test runner under `addons/gut`. Typical ways to run tests:
  - From the Godot editor: enable the GUT plugin (already enabled in `project.godot`) and run the GUT runner UI.
  - From CLI (if configured): the repo contains `addons/gut/gut_cmdln.gd` and `addons/gut/cli/gut_cli.gd`. To run tests via CLI use Godot's `--script` or `--headless` options with GUT's commandline loader. Example pattern (replace path if needed):

```bash
# run headless tests (example; adjust to your Godot binary)
godot4 --headless --script res://addons/gut/gut_cmdln.gd -- -r
```

- VSCode debugging: `addons/gut/gut_vscode_debugger.gd` exists to support running tests through a VSCode launch that targets the Godot process.

# Conventions & patterns agents must follow

- Use Godot resource paths (`res://...`) for loads/preloads. Example: `preload("res://levels/practice/practice.tscn")`.
- Favor group-based node discovery over global searches. Many controllers use `get_tree().get_nodes_in_group(Groups.XYZ)`.
- Respect autoload singletons for shared state and signals (e.g. `Events.add_game_child.connect(...)`). Avoid introducing new global singletons without necessity.
- Abilities and Visitors are data-driven arrays exported to scenes (see `@export var add_player_abilities: Array[Ability]` in `levels/practice/practice.gd`). Preserve that shape when mutating.
- Tests rely on the bundled GUT API (see `addons/gut/test.gd` for usage). When adding tests, follow the `test.gd` conventions and place them alongside code under `addons/gut` pattern or in a `tests/` area if adding new suites.

# Key files & where to look for tasks

- Entry GUI / flow: `game/game.gd`, `levels/title_screen/title_screen.gd`, `levels/practice/practice.gd`.
- Player systems: `entities/player/player_manager.gd`, `entities/player/player.gd`.
- Ball & physics: `entities/ball/ball.gd`, `entities/ball/ball_physics.gd`, `entities/ball/visitors/*`.
- Hitboxes/paddle: `entities/paddle/*`.
- Shared resources: `resources/*.gd` (e.g. `events.gd`, `groups.gd`, `constants.gd`, `scene_tree_util.gd`).
- Tests & tools: `addons/gut/**` (test runner, CLI, helpers).

# Scene code / custom classes (entities/)

AI agents should pay special attention to `entities/` which contains most gameplay Scene scripts. Common patterns:

- **class_name usage:** many entity scripts declare `class_name` and a static `SCENE` preload + `create()` factory. Example: `entities/player/player.gd` (`class_name Player`, `SCENE = preload(...); static func create() -> Player`). Prefer using `SCENE.instantiate()` to create nodes.
- **Exported data:** Scenes and `Resource` classes use `@export` extensively. Examples:
  - `entities/paddle/paddle.gd` exports `abilities: Array[Ability]` and wires them into an `AbilityController` at `_ready()`.
  - `entities/ability/ability.gd` is a `Resource` with exported fields like `name`, `ball_hits`, `passive`, and arrays of `Visitor` scripts (`on_activate`, `on_hit_ball`).
- **Groups:** entity nodes add themselves to groups in `_ready()` (e.g. `add_to_group(Groups.PLAYER)` in `entities/player/player.gd` or `Groups.BALL` in `entities/ball/ball.gd`). Use group iteration when modifying collections of entities.
- **Visitor pattern:** visitors are lightweight callable objects applied to nodes. Entities expose an `accept(v: Visitor)` method and call visitor variants like `if v is PaddleVisitor: v.visit_paddle(self)` (see `entities/paddle/paddle.gd`). Visitors are stored in exported arrays and applied with `Visitor.visit_any(node, visitors_array)`.
- **Signal wiring & controllers:** entity scenes commonly contain child controller nodes (hitbox, ability_controller, health) and wire signals in `_ready()` (examples: `_hitbox_controller.hit.connect(_ability_controller.hit)`, `hitbox.accepted_visitor.connect(accept)`). When editing or moving code, preserve these connections or update where wiring happens.
- **Resources vs Scenes:** `Ability` is implemented as a `Resource` (not a Node). When adding abilities to scenes, code appends `Ability` resources to arrays on nodes (see `levels/practice/practice.gd`). Keep `Resource` fields serializable (exported) rather than embedding runtime-only state.

Reference files to inspect for patterns:

- `entities/player/player.gd`, `entities/player/player_manager.gd`
- `entities/paddle/paddle.gd`, `entities/paddle/paddle_hitbox.gd`, `entities/paddle/paddle_hitbox_controller.gd`
- `entities/ball/ball.gd`, `entities/ball/ball_physics.gd`, `entities/ball/ball_hitbox.gd`, `entities/ball/visitors/*`
- `entities/ability/ability.gd`, `entities/ability/ability_controller.gd`

When modifying scene scripts, prefer minimal edits: update exported properties, add visitors as Resources, and hook signals in `_ready()` to keep scenes editor-friendly.

# Examples for AI edits

- Small change: to iterate players, modify `PlayerManager` or use `get_tree().get_nodes_in_group(Groups.PLAYER)`; see `levels/practice/practice.gd` for removal of abilities.
- Adding new autoload: update `project.godot` autoload section and place the script under `resources/` or `entities/`.
- Adding new GUT tests in the project: 'tests' folder should go in the same directory as the code being tested
- There is no need to eliminate duplicate numeric ids
- Do not modify files in the `addons/` folder

# Concrete Examples

Below are short, copy-paste examples that reflect patterns used in `entities/`.

- Instantiate a `Player` and add to the current scene:

```gdscript
var player: Player = Player.create()
player.global_position = Vector2(100, 200)
add_child(player)
```

- Add an `Ability` Resource to a player's paddle (abilities are Resources, keep them exported):

```gdscript
var ability_res := preload("res://entities/ability/some_ability.tres")
player.paddle.abilities.append(ability_res)
```

- Apply a Visitor to a node (many visitors are scripts under `entities/*/visitors`):

```gdscript
var speed_visitor = preload("res://entities/ball/visitors/speed.gd").new()
Visitor.visit_any(ball, [speed_visitor])
```

- Typical Paddle signal wiring (preserve these connections when refactoring):

```gdscript
_hitbox_controller.hit.connect(_ability_controller.hit)
_hitbox_controller.accepted_visitor.connect(accept)
_ability_controller.accepted_visitor.connect(accept)
_health_controller.damage_taken.connect(_on_health_damage_taken)
```

# VSCode: example tasks and launch snippets

If you want quick local test runs from VSCode, add the following to `.vscode/tasks.json` and `.vscode/launch.json`. Replace `godot4` with your Godot binary path if necessary (for macOS it might be `/Applications/Godot.app/Contents/MacOS/Godot` or a custom symlink).

`.vscode/tasks.json` (runs GUT headless):

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "gut: run headless tests",
      "type": "shell",
      "command": "godot4 --headless --script res://addons/gut/gut_cmdln.gd -- -r",
      "problemMatcher": []
    },
    {
      "label": "gut: run tests (vscode debug)",
      "type": "shell",
      "command": "godot4 --headless --script res://addons/gut/gut_vscode_debugger.gd -- -r",
      "problemMatcher": []
    }
  ]
}
```

`.vscode/launch.json` (calls the task; adjust as needed):

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run GUT tests (headless)",
      "type": "pwa-node",
      "request": "launch",
      "program": "${workspaceFolder}",
      "preLaunchTask": "gut: run headless tests",
      "console": "integratedTerminal"
    }
  ]
}
```

Note: VSCode does not have a native Godot debugger type. The launcher above just runs the task; the repo includes `addons/gut/gut_vscode_debugger.gd` which integrates with some VSCode workflows — adapt the `command` to your environment.

# Safety and assumptions

- Do not change Godot editor/plugin configs unless necessary; `project.godot` already enables GUT.
- Keep Resource paths and exported properties stable to avoid breaking scenes in the editor.

# Quick grep shortcuts for an agent

- Find group usage: `grep -R "get_nodes_in_group(" -n`.
- Find autoloads: open `project.godot` and search `[autoload]`.
- Find tests: search `addons/gut/test.gd` and files under `addons/gut`.

# Feedback

If any critical execution or CI commands are missing (e.g., exact Godot binary name used in CI), tell me what environment you use to run Godot and I will add precise run/test commands.
