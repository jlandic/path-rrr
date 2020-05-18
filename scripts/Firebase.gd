extends Node

const CONFIG_FILE_PATH = "res://config/config.json"

const REGISTER_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s"
const LOGIN_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s"
const FIRESTORE_URL = "https://firestore.googleapis.com/v1beta1/projects/%s/databases/(default)/documents/"

var user_info = {}
var config = {
    "project_key": "",
    "project_id": ""
}

func _ready() -> void:
    _load_config()

func _firestore_url(path: String) -> String:
    return (FIRESTORE_URL % config.project_id) + path

func _load_config() -> void:
    var file = File.new()

    if not file.file_exists(CONFIG_FILE_PATH):
        print("No config.json file was found")
        return

    file.open(CONFIG_FILE_PATH, File.READ)
    var text = file.get_as_text()
    config = parse_json(text)
    file.close()

func _get_user_info(response: Array) -> Dictionary:
    var body = JSON.parse(response[3].get_string_from_ascii()).result as Dictionary
    return {
        "token": body.idToken,
        "id": body.localId
    }

func _get_request_headers() -> PoolStringArray:
    return PoolStringArray([
        "Content-Type: application/json",
        "Authorization: Bearer %s" % user_info.token
    ])

func register(email: String, password: String, nickname: String, lucky_number: String, http: HTTPRequest, storeHttp: HTTPRequest) -> void:
    var body = {
        "email": email,
        "password": password
    }
    
    http.request(REGISTER_URL % config.project_key, [], true, HTTPClient.METHOD_POST, to_json(body))
    var response = yield(http, "request_completed") as Array
    if response[1] == 200:
        user_info = _get_user_info(response)
        _create_user_profile(nickname, lucky_number, storeHttp)
        
func login(email: String, password: String, http: HTTPRequest) -> void:
    var body = {
        "email": email,
        "password": password,
        "returnSecureToken": true
    }
    
    http.request(LOGIN_URL % config.project_key, [], true, HTTPClient.METHOD_POST, to_json(body))
    var response = yield(http, "request_completed") as Array
    if response[1] == 200:
        user_info = _get_user_info(response)

func update_room_index(room_index: int, http: HTTPRequest) -> void:
    var path = "users/%s" % user_info.id
    var fields = {
        "room_index": { "integerValue": room_index },
        "quest_index": { "integerValue": GameData.profile.quest_index },
        "nickname": { "stringValue": GameData.profile.nickname },
        "seed": { "integerValue": GameData.profile.seed }
    }
    update_document(path, fields, http)

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
    var document = {
        "fields": fields
    }
    var body = to_json(document)
    var url = _firestore_url(path)
    http.request(url, _get_request_headers(), true, HTTPClient.METHOD_POST, body)

func get_document(path: String, http: HTTPRequest) -> void:
    var url = _firestore_url(path)
    http.request(url, _get_request_headers(), true, HTTPClient.METHOD_GET)

func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
    var document = {
        "fields": fields
    }
    var body = to_json(document)
    var url = _firestore_url(path)
    http.request(url, _get_request_headers(), true, HTTPClient.METHOD_PATCH, body)

func delete_document(path: String, http: HTTPRequest) -> void:
    var url = _firestore_url(path)
    http.request(url, _get_request_headers(), true, HTTPClient.METHOD_DELETE)

func _create_user_profile(nickname: String, lucky_number: String, http: HTTPRequest) -> void:
    var profile = {
        "nickname": { "stringValue": nickname },
        "seed": { "integerValue": lucky_number.to_int() },
        "quest_index": { "integerValue": 0 },
        "room_index": { "integerValue": 0 }
    }

    save_document(
        "users?documentId=%s" % user_info.id,
        profile,
        http
    )
