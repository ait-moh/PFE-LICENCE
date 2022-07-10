extends Sprite

onready var data = preload("res://new_nativescript.gdns").new()

func _ready():
	data._process()
