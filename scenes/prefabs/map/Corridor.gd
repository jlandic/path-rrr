extends Node2D

const WALL_SCENE = preload("res://scenes/prefabs/tiles/Wall.tscn")
const FLOOR_SCENE = preload("res://scenes/prefabs/tiles/Floor.tscn")

export var direction = Vector2.RIGHT

export var tile_size: int = 16

func _ready() -> void:
    var cut = int(rand_range(1, direction.x - 3))
    var going_up = direction.y < 0

    for x in cut:
        _build_tile(x, -1, WALL_SCENE)
        _build_tile(x, 0, FLOOR_SCENE)
        _build_tile(x, 1, FLOOR_SCENE)
        _build_tile(x, 2, WALL_SCENE)
    
    for y in range(1 if going_up else 0, direction.y, -1 if going_up else 1):
        _build_tile(cut, y, FLOOR_SCENE)
        _build_tile(cut + 1, y, FLOOR_SCENE)
        if (y < 0 and y > direction.y + 2) or \
            (y > 1 and y < direction.y - 2):
            _build_tile(cut - 1, y, WALL_SCENE)
            _build_tile(cut + 2, y, WALL_SCENE)

    for x in range(cut + 2, direction.x):
        if !going_up:
            _build_tile(x, direction.y - 2, FLOOR_SCENE)
            _build_tile(x, direction.y - 1, FLOOR_SCENE)
            _build_tile(x, direction.y - 3, WALL_SCENE)
        if going_up:
            _build_tile(x, direction.y + 1, FLOOR_SCENE)
            _build_tile(x, direction.y + 2, FLOOR_SCENE)
            _build_tile(x, direction.y + 3, WALL_SCENE)
        _build_tile(x, direction.y, WALL_SCENE)

    _build_angle_open_left(cut, 0, going_up)
    _build_angle_open_right(cut - 1, direction.y, going_up)

func _build_tile(x: int, y: int, scene: PackedScene) -> void:
    var tile = scene.instance()
    tile.position = Vector2(x * tile_size, y * tile_size)
    add_child(tile)

func _build_angle_open_left(x: int, y: int, going_up: bool) -> void:
    if going_up:
        _build_tile(x, y + 2, WALL_SCENE)
        _build_tile(x + 1, y + 2, WALL_SCENE)
        _build_tile(x + 2, y + 2, WALL_SCENE)
        _build_tile(x + 2, y + 1, WALL_SCENE)
        _build_tile(x + 2, y + 0, WALL_SCENE)
    else:
        _build_tile(x, y - 1, WALL_SCENE)
        _build_tile(x + 1, y - 1, WALL_SCENE)
        _build_tile(x + 2, y - 1, WALL_SCENE)
        _build_tile(x + 2, y, WALL_SCENE)
        _build_tile(x + 2, y + 1, WALL_SCENE)

func _build_angle_open_right(x: int, y: int, going_up: bool) -> void:
    if going_up:
        _build_tile(x, y + 2, WALL_SCENE)
        _build_tile(x, y + 1, WALL_SCENE)
        _build_tile(x, y, WALL_SCENE)
        _build_tile(x + 1, y, WALL_SCENE)
        _build_tile(x + 2, y, WALL_SCENE)
    else:
        _build_tile(x, y - 2, WALL_SCENE)
        _build_tile(x, y - 1, WALL_SCENE)
        _build_tile(x, y, WALL_SCENE)
        _build_tile(x + 1, y, WALL_SCENE)
        _build_tile(x + 2, y, WALL_SCENE)
