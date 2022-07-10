extends TextureButton
onready var MusicStateLabel := $MusicLabel
func _ready():
	connect("pressed",self,"_on_pressed")
	

func _on_pressed():
	if MusicStateLabel.text == "Music Off":
		audio_player.StopStream("music")
		MusicStateLabel.text = "Music On"
	else:
		audio_player.playStream("music")
		MusicStateLabel.text = "Music Off"
	
