extends Control

const MODULE_ITEM_COMPONENT: PackedScene = preload("res://views/components/ModuleItem.tscn")

@onready var _modules_container: VBoxContainer = %Modules
@onready var _tree: Tree = %ShipsLayouts

var _layouts: Array
var _modules: Array
var _ships: Array
var _slots: Array

func _get_data_items() -> void:
  var _layouts_paths: PackedStringArray = DirAccess.get_files_at("res://data/layouts/")
  var _modules_paths: PackedStringArray = DirAccess.get_files_at("res://data/modules/")
  var _ships_paths: PackedStringArray = DirAccess.get_files_at("res://data/ships/")
  var _slots_paths: PackedStringArray = DirAccess.get_files_at("res://data/slots/")

  _layouts = Array(_layouts_paths).map(func(path): return load("res://data/layouts/" + path))
  _modules = Array(_modules_paths).map(func(path): return load("res://data/modules/" + path))
  _ships = Array(_ships_paths).map(func(path): return load("res://data/ships/" + path))
  _slots = Array(_slots_paths).map(func(path): return load("res://data/slots/" + path))

  _tree.clear()
  _tree.hide_root = true

  var _root: TreeItem = _tree.create_item()

  var _layouts_root: TreeItem = _tree.create_item(_root)
  var _ships_root: TreeItem = _tree.create_item(_root)

  _layouts_root.set_text(0, "Layouts")
  _ships_root.set_text(0, "Ships")

  for _layout in _layouts:
    var _new_item: TreeItem = _tree.create_item(_layouts_root)

    _new_item.set_text(0, _layout.name)

  for _ship in _ships:
    var _new_item: TreeItem = _tree.create_item(_ships_root)

    _new_item.set_text(0, _ship.name)

  GDUtil.queue_free_children(_modules_container)
  for _module in _modules:
    var _new_module_item: Control = MODULE_ITEM_COMPONENT.instantiate()

    _new_module_item.data = _module
    _modules_container.add_child(_new_module_item)

func _on_state_changed(state_key, substate):
  pass

func _ready():
  Store.state_changed.connect(self._on_state_changed)

  _get_data_items()

  print(_layouts)
  print(_modules)
  print(_ships)
  print(_slots)
