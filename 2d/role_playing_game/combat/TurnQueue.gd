extends Node

var queue = []:
    set(value):
        queue.clear()
        for node in value:
            if not node is Combatant:
                continue
            queue.append(node)
            node.active = false
        if queue.size() > 0:
            self.active_combatant = queue[0]

var active_combatant = null:
    set(value):
        active_combatant = value
        active_combatant.active = true
        emit_signal("active_combatant_changed", active_combatant)

signal active_combatant_changed(active_combatant)

func initialize():
    var combatants_list = get_parent().get_child(0)
    queue = combatants_list.get_children()
    play_turn()


func play_turn():
    await active_combatant.turn_finished
    get_next_in_queue()
    play_turn()


func get_next_in_queue():
    var current_combatant = queue.pop_front()
    current_combatant.active = false
    queue.append(current_combatant)
    self.active_combatant = queue[0]
    return active_combatant


func remove(combatant):
    var new_queue = []
    for n in queue:
        new_queue.append(n)
    new_queue.remove(new_queue.find(combatant))
    combatant.queue_free()
    self.queue = new_queue
