extends Node2D

@onready var _better_camera = get_tree().get_first_node_in_group("better_cam")
@onready var _ship: Ship = $"./Ship"

func _physics_process(_delta: float) -> void:
  var _move_direction: Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

  if GDUtil.reference_safe(_ship):
    _ship.move(_move_direction)

    _better_camera.set_target_position(_ship.global_position)
