extends Area2D
class_name Player
var plBullet := preload("res://Bullet/Bullet.tscn")

onready var p = preload("res://new_nativescript.gdns").new()
onready var AnimatedSprite := $AnimatedSprite
onready var FiringPositions :=$FiringPositions
onready var FireDelayTimer:=$FireDelayTimer
onready var InvincibilityTimer :=$InvincibilityTimer
onready var shieldSprite := $Shield

export var speed: float = 100
export var fireDelay: float = 0.1
export var life: int = 3
export var damaegeInvincibilityTimer := 2.0

var s: int = 0
var vel := Vector2(0, 0)
var time_star = 0 
var time_now1 = 0
var time_now2 = 0
func _ready():
	shieldSprite.visible = false
	Signals.emit_signal("on_player_life_changed", life)
	p._ready()
func _process(delta):
	#Animate
	time_star = 0 
	time_now1 = 0
	time_now2 = 0
	time_star = OS.get_ticks_msec()
	if vel.x < 0:
		AnimatedSprite.play("Left")
	elif vel.x > 0:
		AnimatedSprite.play("Right")
	else:
		AnimatedSprite.play("Straight")	
	var dirVec := Vector2(0, 0)
	var k =  p.processPlayer()
	time_now1 = OS.get_ticks_msec()
	var time_rec = time_now1 - time_star
		
	print("le gest " ,k," time de reconnaissance = ", time_rec)
	if k==3:
		dirVec.x = -1
	elif k==4:
		dirVec.x = 1
	if k==1:
		dirVec.y = -1
	elif k==2:
		dirVec.y = 1  
	if k==0:
		s = s+1
		if s==10:
			s=0
			p.pause()
	if k != 0:
		s=0		
	vel = dirVec.normalized() * speed	
	position += vel * delta
	
	#make sure that we are within the screen 
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)
	
	
	#check if shooting
	if k==5 and FireDelayTimer.is_stopped():
		FireDelayTimer.start(fireDelay)
		for child in FiringPositions.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)
			audio_player.playStream("laser_ship")
	time_now2 = OS.get_ticks_msec()
	var time_reponse = time_now2 - time_star
	print("time de reponse de jeux = ",time_reponse)
	
func damage(amount: int):
	if !InvincibilityTimer.is_stopped():
		return
		
	InvincibilityTimer.start(damaegeInvincibilityTimer)	
	shieldSprite.visible = true
	
	life -= amount
	Signals.emit_signal("on_player_life_changed", life)
	
	var cam := get_tree().current_scene.find_node("Cam", true, false)
	cam.shake(20)
	
	if life <= 0:
		audio_player.playStream("explosion")
		queue_free()
		get_tree().change_scene("res://Main_menu/Main_menu.tscn")
	


func _on_InvincibilityTimer_timeout():
	shieldSprite.visible = false
