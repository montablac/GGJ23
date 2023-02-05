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
var StairsCount = 0

var Origin = Vector3(0.0,0.0,0.0)

var Passes = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Origin = self.global_transform.origin

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
	
	
	Force = Vector3(0.0,Speed * -1.0,0.0);
	
	if(self.is_on_floor()):
		Jumping = false
		emit_signal("PlayerOnGround")
		SlopeHelper += (self.get_floor_angle() * slopepercentage)
	
	if(Input.is_key_pressed(KEY_D) && !Jumping):
		Direction += 1.0;
	
	if(Input.is_key_pressed(KEY_A) && !Jumping):
		Direction += -1.0;
	
	if(Input.is_key_pressed(KEY_SPACE)):
		if(self.is_on_floor()):
			emit_signal("PlayerOffGround")
			JumpDirection = self.get_floor_normal()
			Jumping = true
			JumpAmount = JumpPower
			SavedDirection = Direction
	
	if(Input.is_key_pressed(KEY_Q) && NearTree):
		Passes += 1
		emit_signal("Change_World", Passes)
		NearTree = false
		if(Passes < 3):
			self.global_transform.origin = Origin
		print(Passes)
	
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
	NearTree = true


func _on_Area_area_exited(area):
	NearTree = false

func OnStairs(area):
	StairsCount += 1
	if(StairsCount > 0):
		slopepercentage = 1.8
	
func OffStairs(area):
	StairsCount += 1
	if(StairsCount == 0):
		slopepercentage = 0.5
