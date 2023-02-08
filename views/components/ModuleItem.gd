extends Control

var data: ModuleData

@onready var _label: Label = %Label

func _ready():
  _label.text = data.name
