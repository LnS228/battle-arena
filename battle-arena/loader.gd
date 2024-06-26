extends Node


enum Mode { Local, Client, Server, Home }


@onready var offline_map: = preload("res://map/offline.tscn")
@onready var online_map: = preload("res://map/online.tscn")
@onready var home: = preload("res://lobby/lobby.tscn")


var _launched: bool
var _ip_regex: = RegEx.create_from_string("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$")


func _ready() -> void:
    var args: = OS.get_cmdline_user_args()
    
    for i in args.size():
        match args[i]:
            "--server":
                _try_start(Mode.Server)
            "--client":
                _try_start(Mode.Client)
            "--local":
                _try_start(Mode.Local)
            "--ip":
                i += 1
                _change_ip(args[i])


func start_home() -> void:
    _try_start(Mode.Home)


func start_offline() -> void:
    _try_start(Mode.Local)


func _try_start(mode: Mode) -> void:
    if _launched:
        printerr("Cannot call %s with other launching arguments." % mode)
        return
    
    _launched = true
    _start.call_deferred(mode)


func _change_ip(ip: String) -> void:
    var result: = _ip_regex.search(ip)
    if not result: return
    ProjectSettings.set_setting("application/run/ip_address", ip)


func _start(mode: Mode) -> void:
    match mode:
        Mode.Local:
            get_tree().change_scene_to_packed(offline_map)
        Mode.Client, Mode.Server:
            get_tree().change_scene_to_packed(online_map)
            ProjectSettings.set_setting("application/run/server", mode == Mode.Server)
        Mode.Home:
            get_tree().change_scene_to_packed(home)
