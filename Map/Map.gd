extends Node2D

export (PackedScene) var EnemyTank

func _ready():
	$EnemyTimer.start()
	set_camera_limits()
	Input.set_custom_mouse_cursor(load("res://assets/assets/UI/crossair_black.png"),Input.CURSOR_ARROW,Vector2(16,16))
func set_camera_limits():
	var map_limits = $Ground.get_used_rect()
	var map_cellsize = $Ground.cell_size
	
	$Player/Camera2D.limit_left =map_limits.position.x * map_cellsize.x
	$Player/Camera2D.limit_right =map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top =map_limits.position.y * map_cellsize.y
	$Player/Camera2D.limit_bottom =map_limits.end.y * map_cellsize.y
	
func _on_Tank_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position,_direction)
	

func _on_EnemyTimer_timeout():
	print("spawn")	
	var dir = Vector2(1,0)
	var e = EnemyTank.instance()
	add_child(e)
	e.spawnEnemy(dir)
