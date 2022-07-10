extends TextureButton

func _ready():
	connect("pressed",self,"_on_pressed")

func _on_pressed():
	get_tree().change_scene("res://MainScene/Gameplay.tscn")
