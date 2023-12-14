extends TileMap

var stone_positions: Array = []
var sand_positions: Array = []

func _ready():
	Global.tile_map = self
	stone_positions = get_used_cells(1)
	sand_positions = get_used_cells(2)
	
