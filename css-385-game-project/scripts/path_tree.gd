extends Node2D

var start
var end

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nodes = get_children()
	for i in range(nodes.size()):
		if i == 0: #First node
			start = nodes[i]
			nodes[i].next.append(nodes[i + 1])
		elif i >= nodes.size() - 1: #Last node
			end = nodes[i]
			nodes[i].prev.append(nodes[i - 1])
		elif nodes[i].branch == 0: #If 0, it is normal
			nodes[i].next.append(nodes[i + 1])
			nodes[i].prev.append(nodes[i - 1])
		elif nodes[i].branch == 1: #If 1, it is a merge
			nodes[i].next.append(nodes[i + 1])
			nodes[i].prev.append(nodes[i - 1])
			nodes[i].prev.append(nodes[i - 2])
		elif nodes[i].branch == 2: #If 2, it is a split
			nodes[i].next.append(nodes[i + 2])
			nodes[i].next.append(nodes[i + 1])
			nodes[i].prev.append(nodes[i - 1])
		else: #Invalid, it should not be any other number
			print("Invalid")


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


#func team_start(team) -> Node2D:
	#if team > 0:
		#return start
	#else:
		#return end
