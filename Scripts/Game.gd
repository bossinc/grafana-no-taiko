extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var drumObject = preload("res://Scripts/drum.gd")

const songFile = {
	"hits": {
		500: Enums.HitType.Blue,
		750: Enums.HitType.Red,
		1000: Enums.HitType.Blue,
		2000: Enums.HitType.Red,
		4000: Enums.HitType.Blue,
	}
}

var elapsedTime = 0
var curHit = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	elapsedTime += 10
	_create_hit()
	$HitStream.position.x -= 5;
	_delete_node()
	
func _has_hit(drumHit):
	var node = $HitStream.get_children()[0]
	print(node.global_position.x - 260)
	if (node.global_position.x >= 260 && node.global_position.x <= 300 ):
		node.queue_free()
		return true
	return false
		
	

func _input(event):
	var isRed = event.is_action_pressed("drum_red")
	var isBlue = event.is_action_pressed("drum_blue")
	if($HitStream.get_child_count() == 0):
		return
	
	if isRed:
		print(_has_hit(Enums.HitType.Red))
	if isBlue:
		print(_has_hit(Enums.HitType.Blue))
		
func _create_hit():
	var key = elapsedTime
	if(songFile.hits.has(key)):
		var hit = songFile.hits[key]
		var drum = null
		drum = drumObject.new(hit)
		$HitStream.add_child(drum)
		drum.set_global_position(Vector2(1090, $HitStream.position.y))

func _delete_node():
	if($HitStream.get_child_count() == 0):
		return
	var node = $HitStream.get_children()[0]
	if (node.global_position.x <= 200):
		node.queue_free()
