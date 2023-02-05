extends Spatial

var lastPos = Vector3(0.0,0.0,0.0)
var Jumped = false
var Fall = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var Player = get_tree().get_root().find_node("Player", true, false)
	Player.connect("PlayerOffGround",self,"SignalJump")
	Player.connect("PlayerOnGround",self,"SignalLand")

func SignalJump():
	Jumped = true

func SignalLand():
	Fall = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var AnimRoot = $AnimationTree
	var Speed = -1.0
	var Falling = 0.0
	var Jumping = 0.0
	
	var CurrentPos = self.global_translation
	var Diffrence = CurrentPos - lastPos
	lastPos = CurrentPos
	
	if(Diffrence[0] != 0):
		if(Diffrence[0] < 0):
			self.rotation_degrees = Vector3(0.0,180 + 90,0.0)
		elif(Diffrence[0] > 0):
			self.rotation_degrees = Vector3(0.0,90,0.0)
		if(Diffrence[0] < 0):
			Diffrence[0] *= -1
		Speed = ((Diffrence[0] / 0.17) * 2) - 1
		
		if(Speed > 1.0):
			Speed = 1.0
			
	
	if(Jumped && Diffrence[1] <= 0):
		Fall = true
		Jumped = false
		
	
	if(Jumped):
		Jumping = 1
			
	if(Fall):
		Falling = 1
	
	AnimRoot.set("parameters/speed/blend_amount", Speed)
	AnimRoot.set("parameters/walking/blend_amount", Jumping)
	AnimRoot.set("parameters/running/blend_amount", Jumping)
	AnimRoot.set("parameters/falling/blend_amount", Falling)
	AnimRoot.set("parameters/Standing/blend_amount", Jumping)
