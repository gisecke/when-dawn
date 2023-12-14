extends Marker2D

var meteor_path:PackedScene
var chest_path:PackedScene

@export var attack_area_collision: CollisionShape2D

@export var radius: float


var offset_position:Vector2

func _ready() -> void:
	meteor_path = load("res://scenes/itens/meteor/meteor_body.tscn")
	chest_path = load("res://scenes/itens/chest_body.tscn")
	var meteor:RigidBody2D = meteor_path.instantiate()
	call_deferred("add_child", meteor)
	
	var random_angle:int = randi_range(90, 270)
	offset_position = Vector2(
		sin(deg_to_rad(random_angle)) * radius, 
		cos(deg_to_rad(random_angle)) * radius
		)
	meteor.global_position = offset_position



func on_area_floor_entered(body):
	if body.get_class() == 'RigidBody2D' and body.name == 'MeteorBody':
		Global.camera.shake_camera(5)
		attack_area_collision.call_deferred('set_disabled', false)
		await get_tree().create_timer(0.2).timeout
		attack_area_collision.call_deferred('set_disabled', true)
		spawn_chest()
		queue_free()
		

func spawn_chest() -> void:
	var chest:StaticBody2D = chest_path.instantiate()
	get_parent().call_deferred("add_child", chest)
	get_parent().call_deferred('move_child', chest, Global.player.get_index())
	chest.global_position = self.global_position
