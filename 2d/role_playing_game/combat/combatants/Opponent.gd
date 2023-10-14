extends Combatant

func set_active(value):
    active = value
    if active == false:
        return

    if not $Timer.is_inside_tree():
        return
    $Timer.start()
    await $Timer.timeout
    var target
    for actor in get_parent().get_children():
        if not actor == self:
            target = actor
            break
    attack(target)
