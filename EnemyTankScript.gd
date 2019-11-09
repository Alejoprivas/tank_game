extends "res://tanks/Tank.gd"

onready var parent = get_parent()
export (float) var turret_speed
export (int) var detect_radius

var speed = 0
var target = null

func _ready():
	var circle = CircleShape2D.new()
	$UnitDisplay/HealthBar.value = max_health
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func control(delta):
	if  $LookAhead.is_colliding() or $LookAhead2.is_colliding():
		speed = lerp(speed,0,0.1)
	else:
		speed = lerp(speed,max_speed,0.1)
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)
		position = Vector2()
	else:
		pass	
	
func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir,
		turret_speed* delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			shoot()
			
func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		target=body

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		target=null

