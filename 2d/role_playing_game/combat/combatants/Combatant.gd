class_name Combatant
extends Node

@export var damage: int = 1
@export var defense: int = 1
var active = false:
    set(value):
        active = value
        set_process(value)
        set_process_input(value)

        if not active:
            return
        if $Health.armor >= $Health.base_armor + defense:
            $Health.armor = $Health.base_armor

signal turn_finished

func attack(target):
    target.take_damage(damage)
    emit_signal("turn_finished")


func consume(item):
    item.use(self)
    emit_signal("turn_finished")


func defend():
    $Health.armor += defense
    emit_signal("turn_finished")


func flee():
    emit_signal("turn_finished")


func take_damage(damage_to_take):
    $Health.take_damage(damage_to_take)
    $Sprite/AnimationPlayer.play("take_damage")
