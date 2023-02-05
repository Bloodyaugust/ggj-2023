extends Node2D

@onready var _ship: Ship = $"./Ship"

func _physics_process(_delta: float) -> void:
  var _move_direction: Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

  _ship.move(_move_direction)
