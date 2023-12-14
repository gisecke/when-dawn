extends RigidBody2D

class_name MeteorBody


@export var texture_list:Array
@export var sprite_texture:Sprite2D
@export var floor_area:Area2D
@export var explosion_particles:GPUParticles2D
@export var smoke_particles:GPUParticles2D
@export var fire_particles: GPUParticles2D


var spawner_marker:Marker2D
var direction: Vector2

	
func _enter_tree():
	var random_number: int = randi() % 4
	sprite_texture.texture = load(texture_list[random_number])
	
	spawner_marker = get_parent()
	

func _physics_process(_delta) -> void:
	if spawner_marker != null:
		direction = global_position.direction_to(spawner_marker.global_position)
		add_constant_force(direction)



func on_floor_area_entered(area):
	if area.get_parent().get_class() == "Marker2D":
		self.set_physics_process(false)
		fire_particles.set_emitting(false)
		explosion_particles.set_emitting(true)
		smoke_particles.set_emitting(true)
		sprite_texture.queue_free()
		await  get_tree().create_timer(1.0).timeout
		queue_free()


func on_floor_area_exited(area):
	if area.get_parent().get_class() == "Marker2D":
		self.call_deferred('set_freeze_enabled', true)
