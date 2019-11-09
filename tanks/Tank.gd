extends KinematicBody2D

signal health_changed
signal dead
signal shoot
signal take_damage

export (PackedScene) var Bullet
export (int) var max_speed
export (float) var rotation_speed
export (float) var gun_cooldown
export (int) var max_health

var velocity = Vector2()
var can_shoot = true
var alive = true
var health

func _ready():
	health = max_health
	emit_signal('health_changed', health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown

func shoot():
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		#$Turret/Sprite.show()
		#$Turret/Sprite.play()
		var dir = Vector2(1,0).rotated($Turret.global_rotation)
		emit_signal('shoot',Bullet, $Turret/Muzzle.global_position, dir)
		$AnimationPlayer.play("New Anim")

func control(delta):
	pass
	
func take_damage(amount):
	health -= amount
	emit_signal('take_damage',health)
	emit_signal('health_changed',health * 100/max_health)
	if health <= 0:
		explode()

func explode():
	velocity = Vector2()
	$body.hide()
	$Explosion.show()
	$Explosion.play('smoke')
	
func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide(velocity)
	
func _on_GunTimer_timeout():
	can_shoot= true

func _on_Explosion_animation_finished():
	queue_free()
