extends Node
var level = [1, 1, 1]
signal interacted_with_object(object)
signal place_door(position)

#gui
signal character_selected(current_character)
signal reset_to_main()
signal open_diary()
signal enable_end_turn_button()
signal disable_end_turn_button()
signal add_monsters(monsters)
signal get_QS_skills()
signal reset_QS_cooldowns()

#out of dungeon
signal trader_area_entered(coordinates)
signal trader_area_exited()
signal initiate_dialogue() # Player has pressed the "interact" button
signal start_dialogue(_dialogue) # Npc dialogue is transfered to UI
signal chest_area_entered(coordinates)
signal chest_area_exited()

#skills 
signal display_attack_map(centre_pos, cast_range, travel_range, aoe_range)
signal confirmed_attack_cell(cast_pos, direction)
signal play_sound_effect(sound_effect)
signal used_QS_slot(slot)
var _quickselect_slots

#inventory
signal items_changed(indexes)
signal item_collected(item)
signal gold_collected(amount)

#dungeon
signal exit_dungeon()
signal change_level()
signal enter_dungeon()
signal completed_dungeon_generation()
signal end_turn()

#placement
signal spawn_player(char_name)
signal spawn_chest()
signal place_chest(position)
signal spawn_boss()
signal spawn_monster(monster_list)
signal spawn_exit()
signal prompt_level_exit()
signal toggle_exit_level_screen()

#battle
signal attack_player(used_skill)
signal heal_player(used_skill)
signal attack_monster(body, used_skill)
signal heal_monster(body, used_skill)
signal hit_object(object, used_skill)
signal update_actor_list()
signal player_died(characterClass)
signal monster_died(xp_drop)
signal boss_killed()
