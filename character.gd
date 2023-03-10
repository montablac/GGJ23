extends KinematicBody

signal Change_World(NewState)
signal PlayerOffGround
signal PlayerOnGround

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Force = Vector3(0.0,0.0,0.0);
var JumpDirection = Vector3(0.0,0.0,0.0)
var JumpAmount = 0
var SavedDirection = 0
var Jumping = false
var slopepercentage = 0.5
var NearTree = false
var gameend = false
var StairsCount = 0

var Origin = Vector3(0.0,0.0,0.0)

var Passes = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Origin = self.global_transform.origin
	Passes = 0

func _physics_process(delta):
	var Gravity = 1.0
	
	Force[1] -= Gravity
	Force = self.move_and_slide(Force,Vector3(0.0,1.0,0.0),true);



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var Direction = 0;
	var JumpPower = 40;
	var NotMoving = true
	var Gravity = 5.0
	var SlopeHelper = 1.0
	var Speed = 10
	
	if(gameend):
		$Label3D.visible = false
		$Camera.translation[1] += 4.0 * delta
	
	Force = Vector3(0.0,Speed * -1.0,0.0);
	
	if(self.is_on_floor()):
		Jumping = false
		emit_signal("PlayerOnGround")
		SlopeHelper += (self.get_floor_angle() * slopepercentage)
	
	if(Input.is_key_pressed(KEY_D) && !Jumping && !gameend):
		Direction += 1.0;
	
	if(Input.is_key_pressed(KEY_A) && !Jumping && !gameend):
		Direction += -1.0;
	
	if(Input.is_key_pressed(KEY_SPACE) && !gameend):
		if(self.is_on_floor()):
			emit_signal("PlayerOffGround")
			JumpDirection = self.get_floor_normal()
			Jumping = true
			JumpAmount = JumpPower
			SavedDirection = Direction
	
	if(Input.is_key_pressed(KEY_Q) && NearTree && !gameend):
		Passes += 1
		emit_signal("Change_World", Passes)
		NearTree = false
		if(Passes < 3):
			$Timer.start()
			$MeshInstance2.visible = true
			self.global_transform.origin = Origin
		else:
			gameend = true
			$Timer.start(5.0)
	
	if(Jumping):
		Force[0] += SavedDirection * Speed 
		JumpAmount -= JumpPower * delta
		if(JumpAmount >= 0):
			Force += JumpDirection * JumpAmount
	else:
		Force[0] += Direction * Speed * SlopeHelper
	

func _on_Area_body_entered(body):
	slopepercentage = 1.8


func _on_Area_body_exited(body):
	slopepercentage = 0.5


func _on_Area_area_entered(area):
	if(Passes == 0):
		$Label3D["text"] = "Press Q to Rest"
	if(Passes == 1):
		$Label3D["text"] = "Press Q to Dream"
	if(Passes == 2):
		$Label3D["text"] = "Press Q to Plant"
	NearTree = true
	$Label3D.visible = true


func _on_Area_area_exited(area):
	NearTree = false
	$Label3D.visible = false

func OnStairs(area):
	StairsCount += 1
	if(StairsCount > 0):
		print("on stairs")
		slopepercentage = 1.8
	
func OffStairs(area):
	StairsCount -= 1
	if(StairsCount == 0):
		print("off stairs")
		slopepercentage = 0.5


func _on_Timer_timeout():
	if(gameend):
		get_tree().change_scene("res://Menu.tscn")
	else:
		$MeshInstance2.visible = false
