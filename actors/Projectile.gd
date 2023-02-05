extends Node2D
class_name Projectile

var data: ProjectileData
var team: String

@onready var _area2d = %Area2D
@onready var _time_to_live = data.time_to_live

func _on_area2d_entered(entering_area: Area2D) -> void:
  var _ship: Ship = entering_area.get_parent()
    
  if GDUtil.reference_safe(_ship) && _ship.team != team:
    _ship.damage({
      "amount": data.damage_amount,
      "type": data.damage_type,
    })
    queue_free()

func _physics_process(delta: float) -> void:
  var _direction: Vector2 = Vector2.RIGHT

  if !data.homing:
    _direction = _direction.rotated(rotation).normalized()

  translate(_direction * data.speed * delta)

func _process(delta: float) -> void:
  _time_to_live -= delta

  if _time_to_live <= 0.0:
    queue_free()

func _ready() -> void:
  _area2d.connect("area_entered", _on_area2d_entered)
