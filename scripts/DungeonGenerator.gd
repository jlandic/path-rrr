extends Node2D
class_name DungeonGenerator

const ROOM_SCENE = preload("res://scenes/prefabs/map/Room.tscn")
const CORRIDOR_SCENE = preload("res://scenes/prefabs/map/Corridor.tscn")

const TILE_SIZE = 16

var rooms = []

func generate(quest: Dictionary, quest_index: int, seed_number: int) -> void:
    seed(seed_number)

    rooms = []

    var intro_room = ROOM_SCENE.instance()
    intro_room.has_entry = false
    intro_room.has_exit = true
    intro_room.task = quest
    intro_room.quest_index = quest_index
    intro_room.room_index = 0
    rooms.append(intro_room)
    add_child(intro_room)

    for i in quest.tasks.size():
        var room = ROOM_SCENE.instance()
        room.has_entry = true
        room.has_exit = i != quest.tasks.size() - 1
        room.task = quest.tasks[i]
        room.quest_index = quest_index
        room.room_index = i + 1
        rooms.append(room)
        
        add_child(room)
        var previous = rooms[i]
        var y_direction = pow(-1, randi() % 2) # 1 or -1, will go up or down
        var offset = Vector2(
            TILE_SIZE * int(rand_range(25, 30)),
            TILE_SIZE * int(rand_range(10, 20)) * y_direction
        )
        room.position = previous.position + offset
        _link_rooms(previous, room)

func _link_rooms(a: Room, b: Room) -> void:
    var tile_size = a.tile_size
    var corridor = CORRIDOR_SCENE.instance()
    var y_vector_correction = Vector2.UP * tile_size if b.position.y < 0 else Vector2.DOWN * 2 * tile_size
    corridor.position = a.position + a.get_exit_tile_position() + Vector2.RIGHT * tile_size
    corridor.direction = (b.get_entry_tile_position() + y_vector_correction + b.position - a.get_exit_tile_position() - a.position) / tile_size
    
    add_child(corridor)

func get_start_position_for_room(index: int) -> Vector2:
    return rooms[index].global_position + Vector2(TILE_SIZE, TILE_SIZE) * 2
