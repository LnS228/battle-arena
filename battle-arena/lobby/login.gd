extends Control


@onready var loader: = $Loader


var _config: = ConfigFile.new()
var _uuid


const CONFIG_FILE: = "user://local.ini"


func _ready() -> void:
    if OS.has_feature("editor"): _restore()
    else: _try_login_itch()


func on_login_pressed() -> void:
    if $Nickname.text.is_empty(): return
    
    _save_username()
    _save_uuid()
    
    var result: = await Matchmaking.authenticate("%s@custom.email" % $Nickname.text, "password")
    if result: loader.start_home()
    else: loader.start_offline()


func _on_register_pressed() -> void:
    if $Nickname.text.is_empty(): return
    
    _uuid = UUID.v4()
    
    _save_username()
    _save_uuid()
    
    var result: = await Matchmaking.authenticate("%s@custom.email" % $Nickname.text, "password", $Nickname.text, true)
    if result: loader.start_home()


func _restore() -> void:
    var result: = _config.load(CONFIG_FILE)
    if result == ERR_FILE_CANT_OPEN: return
    
    $Nickname.text = _config.get_value("auth", "login", "")
    _uuid = _config.get_value("auth", "uuid", UUID.v4())


func _try_login_itch() -> void:
    var api_key: = OS.get_environment("ITCHIO_API_KEY")
    if api_key.is_empty(): return
    
    $Login.disabled = true
    
    var httpRequest: = HTTPRequest.new()
    add_child(httpRequest)
    httpRequest.request_completed.connect(_on_itch_request_completed)
    
    var headers: = ["Authorization: %s" % api_key]
    
    var error = httpRequest.request("https://itch.io/api/1/jwt/me", headers, HTTPClient.METHOD_GET)
    
    if error != OK:
        push_error("An error occurred in the HTTP request. %d" % error)
        $Login.disabled = false


func _on_itch_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
    var json = JSON.parse_string(body.get_string_from_utf8())
    $Nickname.text = json.user.username
    
    var email: String = "%s@itch.io" % json.user.username
    var password: = Marshalls.utf8_to_base64("%s.%s" % [json.user.username, json.user.id])
    var nakama_result = await Matchmaking.authenticate(email, password, json.user.username, true)
    if not nakama_result:
        push_error("Cannot authenticate: %s" % nakama_result)
    
    if json.user.has("display_name"):
        nakama_result = await Matchmaking.update_account(json.user.display_name, json.user.cover_url)
        if not nakama_result:
            push_error("Cannot update account: %s" % nakama_result)
    
    loader.start_home()


func _save_username() -> void:
    _config.set_value("auth", "login", $Nickname.text)
    _config.save(CONFIG_FILE)


func _save_uuid() -> void:
    _config.set_value("auth", "uuid", _uuid)
    _config.save(CONFIG_FILE)
