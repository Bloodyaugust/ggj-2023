extends Node2D

const MIN_DISTANCE: float = 150.0

@onready var _player: Ship = get_tree().get_first_node_in_group("player")
@onready var _ship: Ship = %Ship

func _physics_process(delta: float) -> void:
  if !GDUtil.reference_safe(_ship):
    queue_free()
    return

  if GDUtil.reference_safe(_player) && _ship.global_position.distance_to(_player.global_position) >= MIN_DISTANCE:
    _ship.move(_ship.global_position.direction_to(_player.global_position))

func _ready() -> void:
  _ship.add_to_group("enemies")
