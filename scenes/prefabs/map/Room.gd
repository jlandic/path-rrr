extends Node2D
class_name Room

const WALL_SCENE = preload("res://scenes/prefabs/tiles/Wall.tscn")
const FLOOR_SCENE = preload("res://scenes/prefabs/tiles/Floor.tscn")
const CORRIDOR_SCENE = preload("res://scenes/prefabs/map/Corridor.tscn")
const DOOR_SCENE = preload("res://scenes/prefabs/objects/Door.tscn")
const NPC_SCENE = preload("res://scenes/prefabs/actors/Npc/Npc.tscn")

export var min_height = 6
export var max_height = 15

export var min_width = 10
export var max_width = 20

export var tile_size = 16

export var has_entry = true
export var has_exit = true

var width = min_width
var height = min_height
var entry_door_y = 1
var exit_door_y = 1
var task: Dictionary = {}

var quest_index
var room_index

func _ready() -> void:
    width = int(rand_range(min_width, max_width))
    height = int(rand_range(min_height, max_height))
    
    entry_door_y = int(rand_range(1, height - 2))
    exit_door_y = int(rand_range(1, height - 2))

    for x in width:
        for y in height:
            _build(x, y)
    
    _build_doors()
    _spawn_npc()

func _build(x: int, y: int) -> void:
    var tile = _get_tile_type(x, y).instance()
    tile.position = Vector2(x * tile_size, y * tile_size)
    add_child(tile)

func _spawn_npc() -> void:
    var npc = NPC_SCENE.instance()
    npc.position = Vector2(
        int(rand_range(width / 2, width - 2)) * tile_size,
        int(rand_range(height / 2, height - 1)) * tile_size
    )
    npc.dialogue = task.dialogue
    add_child(npc)

func _build_doors() -> void:
    if has_exit:
        var tile = DOOR_SCENE.instance()
        var second_tile = DOOR_SCENE.instance()
        
        tile.position = Vector2(width * tile_size - tile_size, exit_door_y * tile_size)
        second_tile.position = Vector2(width * tile_size - tile_size, exit_door_y * tile_size + tile_size)
        
        add_child(tile)
        add_child(second_tile)

    if has_entry:
        var tile = DOOR_SCENE.instance()
        var second_tile = DOOR_SCENE.instance()
        
        tile.position = Vector2(0, entry_door_y * tile_size)
        second_tile.position = Vector2(0, entry_door_y * tile_size + tile_size)
        tile.set_save_on_open(quest_index, room_index)
        add_child(tile)
        add_child(second_tile)

func _get_tile_type(x: int, y: int) -> PackedScene:
    if x == 0 or y == 0 or x == width - 1 or y == height - 1:
        if has_entry and x == 0 and (y == entry_door_y or y == entry_door_y + 1):
            return FLOOR_SCENE
        if has_exit and x == width - 1 and (y == exit_door_y or y == exit_door_y + 1):
            return FLOOR_SCENE
        return WALL_SCENE
    return FLOOR_SCENE

func get_entry_tile_position() -> Vector2:
    return Vector2(0, entry_door_y * tile_size)

func get_exit_tile_position() -> Vector2:
    return Vector2((width - 1) * tile_size, exit_door_y * tile_size)
