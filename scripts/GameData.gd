extends Node

var path = "user://.path-rrr.json"

const DEFAULT = {
    "email": ""
}

var data = {}
var profile = {}

func load_user_config() -> void:
    var file = File.new()
    
    if not file.file_exists(path):
        print("Creating default config")
        _reset_data()
        return

    file.open(path, File.READ)
    var text = file.get_as_text()
    data = parse_json(text)
    file.close()

func save_user_config():
    var file = File.new()
    file.open(path, File.WRITE)
    file.store_line(to_json(data))
    file.close()
    
func _reset_data() -> void:
    data = DEFAULT.duplicate(true)

func start_new_room(room_index: int, http: HTTPRequest) -> void:
    if room_index > profile.room_index:
        Firebase.update_room_index(room_index, http)
