extends TileMap

enum CellType { ACTOR, OBSTACLE, OBJECT }
@export var dialogue_ui: NodePath

func _ready():
    for child in get_children():
        set_cell(0, local_to_map(child.position), child.type, Vector2i(0, 0))


func get_cell_pawn(cell, type = CellType.ACTOR):
    for node in get_children():
        if node.type != type:
            continue
        if local_to_map(node.position) == Vector2i(cell):
            return(node)


func request_move(pawn, direction):
    var cell_start = local_to_map(pawn.position)
    var cell_target = Vector2(cell_start) + direction
    var cell_tile_id = get_cell_source_id(0, cell_target)
    match cell_tile_id:
        -1:
            set_cell(0, cell_target, CellType.ACTOR, Vector2i(0, 0))
            set_cell(0, cell_start, -1)
            return Vector2i(map_to_local(cell_target))
        CellType.OBJECT, CellType.ACTOR:
            var target_pawn = get_cell_pawn(cell_target, cell_tile_id)
            print("Cell %s contains %s" % [cell_target, target_pawn.name])

            if not target_pawn.has_node("DialoguePlayer"):
                return
            get_node(dialogue_ui).show_dialogue(pawn, target_pawn.get_node(^"DialoguePlayer"))
