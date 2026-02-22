extends Node2D

var Saving = true
var Enable_Test = false

@export var MAP_WIDTH = 35
@export var MAP_HEIGHT = 35

@export var File_Name = "SuperRoom"

@onready var Tiles = $TileMapLayer

var File
var Data = {}

var Stored_Tiles = []
var Store_Up = Vector2()
var Store_Right = Vector2()
var Store_Down = Vector2()
var Store_Left = Vector2()

func _ready() -> void:
	branch_path(Vector2(-1000,-1000),"Down",10)
	if Enable_Test == true:
		if Saving == true:
			File = FileAccess.open("res://level files/"+File_Name+".json",FileAccess.WRITE)
			scan_tiles()
		else:
			print_tiles(File_Name,Vector2(25,10),"Right")

func scan_tiles():
	for Tile_X in MAP_WIDTH:
		Stored_Tiles.append([])
		for Tile_Y in MAP_HEIGHT:
			Stored_Tiles[Tile_X].append([Tiles.get_cell_source_id(Vector2(Tile_X,Tile_Y)),Tiles.get_cell_atlas_coords(Vector2(Tile_X,Tile_Y)).x,Tiles.get_cell_atlas_coords(Vector2(Tile_X,Tile_Y)).y])
	for Child in get_children():
		if Child.is_in_group("Map Connector"):
			if Child.Location == "Up":
				Store_Up = Child.position
			if Child.Location == "Right":
				Store_Right = Child.position
			if Child.Location == "Down":
				Store_Down = Child.position
			if Child.Location == "Left":
				Store_Left = Child.position
	Data["level_tiles"] = Stored_Tiles
	Data["Up"] = [Store_Up.x,Store_Up.y]
	Data["Right"] = [Store_Right.x,Store_Right.y]
	Data["Down"] = [Store_Down.x,Store_Down.y]
	Data["Left"] = [Store_Left.x,Store_Left.y]
	Data["Width"] = MAP_WIDTH
	Data["Height"] = MAP_HEIGHT
	File.store_string(JSON.stringify(Data))
	print("Done!")
	File.close()

func print_tiles(Title,Location,Direction):
	var Center_Point = Vector2()
	var Access_File =  FileAccess.open("res://level files/"+Title+".json",FileAccess.READ)
	Access_File = Access_File.get_as_text()
	Access_File = JSON.parse_string(Access_File)
	match Direction:
		"Up":
			Center_Point = Vector2(Access_File["Up"][0],Access_File["Up"][1])
			print(Center_Point)
		"Right":
			Center_Point = Vector2(Access_File["Right"][0],Access_File["Right"][1])
			print(Center_Point)
		"Down":
			Center_Point = Vector2(Access_File["Down"][0],Access_File["Down"][1])
			print(Center_Point)
		"Left":
			Center_Point = Vector2(Access_File["Left"][0],Access_File["Left"][1])
			print(Center_Point)
	
	
	for Tile_X in Access_File["level_tiles"].size()-1:
		for Tile_Y in Access_File["level_tiles"][Tile_X].size()-1:
			if Access_File["level_tiles"][Tile_X][Tile_Y][0] != -1:
				var Relative_Pos = Vector2(Tile_X,Tile_Y) - Vector2(Center_Point.x/32,Center_Point.y/32)
				var Set_Pos = Vector2(Location.x,Location.y)+Relative_Pos
				Tiles.set_cell(Set_Pos,Access_File["level_tiles"][Tile_X][Tile_Y][0],Vector2i(Access_File["level_tiles"][Tile_X][Tile_Y][1],Access_File["level_tiles"][Tile_X][Tile_Y][2]))
	if Direction != "Up":
		Tiles.set_cell((Vector2(Access_File["Up"][0]/32,Access_File["Up"][1]/32)+Vector2(-1,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(1,0))
		Tiles.set_cell((Vector2(Access_File["Up"][0]/32,Access_File["Up"][1]/32)+Vector2(0,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(3,0))
		Tiles.set_cell((Vector2(Access_File["Up"][0]/32,Access_File["Up"][1]/32)+Vector2(1,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(1,1))
	if Direction != "Down":
		Tiles.set_cell((Vector2(Access_File["Down"][0]/32,Access_File["Down"][1]/32)+Vector2(-1,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(3,1))
		Tiles.set_cell((Vector2(Access_File["Down"][0]/32,Access_File["Down"][1]/32)+Vector2(0,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(1,2))
		Tiles.set_cell((Vector2(Access_File["Down"][0]/32,Access_File["Down"][1]/32)+Vector2(1,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(2,2))
	if Direction != "Right":
		Tiles.set_cell((Vector2(Access_File["Right"][0]/32,Access_File["Right"][1]/32)+Vector2(0,-2))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(1,1))
		Tiles.set_cell((Vector2(Access_File["Right"][0]/32,Access_File["Right"][1]/32)+Vector2(0,-1))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(0,1))
		Tiles.set_cell((Vector2(Access_File["Right"][0]/32,Access_File["Right"][1]/32)+Vector2(0,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(0,1))
		Tiles.set_cell((Vector2(Access_File["Right"][0]/32,Access_File["Right"][1]/32)+Vector2(0,1))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(0,1))
		Tiles.set_cell((Vector2(Access_File["Right"][0]/32,Access_File["Right"][1]/32)+Vector2(0,2))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(2,2))
	if Direction != "Left":
		Tiles.set_cell((Vector2(Access_File["Left"][0]/32,Access_File["Left"][1]/32)+Vector2(0,-2))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(1,0))
		Tiles.set_cell((Vector2(Access_File["Left"][0]/32,Access_File["Left"][1]/32)+Vector2(0,-1))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(0,0))
		Tiles.set_cell((Vector2(Access_File["Left"][0]/32,Access_File["Left"][1]/32)+Vector2(0,0))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(0,0))
		Tiles.set_cell((Vector2(Access_File["Left"][0]/32,Access_File["Left"][1]/32)+Vector2(0,1))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(0,0))
		Tiles.set_cell((Vector2(Access_File["Left"][0]/32,Access_File["Left"][1]/32)+Vector2(0,2))-Vector2(Center_Point.x/32,Center_Point.y/32)+Location,1,Vector2i(3,1))



func branch_path(Initial_Position,Initial_Direction,Total_Length):
	var Room_Record = []
	var Room_Count = 0
	var Can_Continue = true
	var Next_Direction = Initial_Direction
	var Next_Position = Initial_Position
	
	while Can_Continue == true && Room_Count < Total_Length:
		var Room_ID = "SuperRoom"
		var Big_Access_File = FileAccess.open("res://level files/"+Room_ID+".json",FileAccess.READ)
		Big_Access_File = Big_Access_File.get_as_text()
		Big_Access_File = JSON.parse_string(Big_Access_File)
		var Big_Center_Point = Vector2()
		
		match Next_Direction:
			"Up":
				Big_Center_Point = Vector2(Big_Access_File["Up"][0],Big_Access_File["Up"][1])
			"Right":
				Big_Center_Point = Vector2(Big_Access_File["Right"][0],Big_Access_File["Right"][1])
			"Down":
				Big_Center_Point = Vector2(Big_Access_File["Down"][0],Big_Access_File["Down"][1])
			"Left":
				Big_Center_Point = Vector2(Big_Access_File["Left"][0],Big_Access_File["Left"][1])
		
		
		var Check_Origin = Next_Position - Vector2(Big_Center_Point.x/32,Big_Center_Point.y/32)
		var Obstructions = 0
		for Tile_X in Big_Access_File["Width"]:
			for Tile_Y in Big_Access_File["Height"]:
				if Tiles.get_cell_atlas_coords(Check_Origin+Vector2(Tile_X,Tile_Y)) != Vector2i(-1,-1):
					Obstructions += 1
					print("Uh oh...")
		if Obstructions >= 8:
			Can_Continue = false
			print("Too bad...")
		else:
			print_tiles(Room_ID,Vector2(Next_Position.x/32,Next_Position.y/32),Next_Direction)
		
		var Previous_Direction = Next_Direction
		var Build_From = ""
		match Previous_Direction:
			"Up":
				Build_From = ["Down","Right","Left"].pick_random()
			"Right":
				Build_From = ["Up","Left","Down"].pick_random()
			"Down":
				Build_From = ["Left","Right","Up"].pick_random()
			"Left":
				Build_From = ["Down","Right","Up"].pick_random()
		var Previous_Position = Next_Position
		match Build_From:
			"Up":
				Next_Direction = "Down"
			"Right":
				Next_Direction = "Left"
			"Down":
				Next_Direction = "Up"
			"Left":
				Next_Direction = "Right"
		Next_Position += Vector2(Big_Access_File[Build_From][0],Big_Access_File[Build_From][1]) - Big_Center_Point
		Room_Count += 1
