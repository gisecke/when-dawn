extends CanvasLayer

signal velocity_changed

@export var whell_node: Control
@export var timer: Timer
@export var node_items: Control

@onready var audio_sfx:AudioSfx = get_node("AudioSfx")
@onready var spell_label:Label = get_node('Control/SpellLabel')

var angle: float = 45
var increment: int = 4
var wait_time_rn: float
var spell_text:String



var items:Dictionary = {
	0: [
		'Apple Gold',
		"res://assets/itens/apples_gold.png", #caminho do item
		'life', #tipo do item
		1.5, #multiplicador
		true # é permanente o efeito?
	],
	1: [
		'Apple Red',
		"res://assets/itens/apples_red.png",
		'life',
		1.2,
		true
	],
	2: [
		'Book Brown',
		"res://assets/itens/books_brown.png",
		'xp',
		1.5,
		false
	],
	3: [
		'Book Green',
		"res://assets/itens/books_green.png",
		'xp',
		1.2,
		false
	],
	4: [
		'Book Red',
		"res://assets/itens/books_red.png",
		'xp',
		1.5,
		false
	],
	5: [
		'Coffee',
		"res://assets/itens/coffee.png",
		'velocity attack',
		1.5,
		false
	],
	6: [
		'Orange',
		"res://assets/itens/orange.png",
		'life',
		2,
		true
	],
	7: [
		'Spinach',
		"res://assets/itens/spinach.png",
		'attack',
		1.5,
		false
	]
}

var items_array:Array
var garbage:Array

func _ready():
	get_tree().call_group('spawn_timer', 'pause_timer', true)
	Global.player.set_physics_process(false)
	for e in Global.enemy.size():
		Global.enemy[e].set_physics_process(false)
	wait_time_rn = randf_range(2.0, 5.0)
	timer.wait_time = wait_time_rn
	var tween: Tween = create_tween()
	tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_IN_OUT)
	for child in node_items.get_children():
		var rng: int = randi() % 8
		while items.get(rng) == null:
			rng = randi() % 8
		child.texture = load(items.get(rng)[1])
		items_array.append(items.get(rng))
		items.erase(rng)



func _process(delta):
	if scale >= Vector2(1.0, 1.0):
		whell_node.rotation += deg_to_rad(angle) *delta * increment
		if rad_to_deg(whell_node.rotation) >= 360:
			whell_node.rotation = 0


func on_timer_timeout():
	if increment > 0:
		increment -= 1
		emit_signal("velocity_changed")
		if increment == 0:
			await get_tree().create_timer(0.2).timeout
			adjust_wheel()
			await get_tree().create_timer(0.5).timeout
			for child in node_items.get_children():
				child.get_child(0).get_child(0).disabled = false
			
	else:
		timer.stop()
		
		
func adjust_wheel() -> void:
	var tween: Tween = create_tween()
	if rad_to_deg(whell_node.rotation) >= 0 and rad_to_deg(whell_node.rotation) <= 45:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(23), 0.5).set_ease(Tween.EASE_IN_OUT)
	elif rad_to_deg(whell_node.rotation) > 45 and rad_to_deg(whell_node.rotation) <= 90:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(68), 0.5).set_ease(Tween.EASE_IN_OUT)
	elif rad_to_deg(whell_node.rotation) > 90 and rad_to_deg(whell_node.rotation) <= 135:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(113), 0.5).set_ease(Tween.EASE_IN_OUT)
	elif rad_to_deg(whell_node.rotation) > 135 and rad_to_deg(whell_node.rotation) <= 180:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(158), 0.5).set_ease(Tween.EASE_IN_OUT)
	elif rad_to_deg(whell_node.rotation) > 180 and rad_to_deg(whell_node.rotation) <= 225:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(203), 0.5).set_ease(Tween.EASE_IN_OUT)
	elif rad_to_deg(whell_node.rotation) > 225 and rad_to_deg(whell_node.rotation) <= 270:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(248), 0.5).set_ease(Tween.EASE_IN_OUT)
	elif rad_to_deg(whell_node.rotation) > 270 and rad_to_deg(whell_node.rotation) <= 315:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(293), 0.5).set_ease(Tween.EASE_IN_OUT)
	elif rad_to_deg(whell_node.rotation) > 315:
		tween.tween_property(whell_node, 'rotation', deg_to_rad(338), 0.5).set_ease(Tween.EASE_IN_OUT)


func on_area_arrow_entered(area: Area2D) -> void:
	var index: int = area.get_parent().get_index()
	set_spell_text(items_array[index][0], items_array[index][2], items_array[index][3])
	get_tree().call_group('stats', 'bonus_improvment', items_array[index][2], items_array[index][3], items_array[index][4])
	await get_tree().create_timer(2.0).timeout
	var tween: Tween = create_tween()
	tween.tween_property(self, 'scale', Vector2(0, 0), 0.5).set_ease(Tween.EASE_IN_OUT)
	Global.player.set_physics_process(true)
	for e in Global.enemy.size():
		Global.enemy[e].set_physics_process(true)
	get_tree().call_group('spawn_timer', 'pause_timer', false)
	get_tree().call_group('chest', 'play_kill_animation')
	queue_free()


func _on_velocity_changed():
	match increment:
		3:
			audio_sfx.play_audio('res://assets/sounds/itens/wheel_fortune_vel_3.ogg')
		2:
			audio_sfx.play_audio('res://assets/sounds/itens/wheel_fortune_vel_2.ogg')
		1:
			audio_sfx.play_audio('res://assets/sounds/itens/wheel_fortune_vel_1.ogg')
		0:
			audio_sfx.stop()

func set_spell_text(name_spell:String, type:String, value:float) -> void:
	spell_text = name_spell+": multiply your "+type+" "+str(value)+"x"
	spell_label.text = spell_text
