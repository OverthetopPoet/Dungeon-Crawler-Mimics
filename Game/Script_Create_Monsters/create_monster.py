# This script can be used to create monsters using the monster template and naming conventions of deepdivegamestudio

import os
import copy


alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

savedir = "output"
for filename in os.listdir("input"):
    monster_name = copy.deepcopy(filename)
    monster_name = monster_name.replace("Idle", "")
    monster_name = monster_name.replace("Side", "")
    monster_name = monster_name.replace("Front", "")
    monster_name = monster_name.replace("idle", "")
    monster_name = monster_name.replace("side", "")
    monster_name = monster_name.replace("front", "")
    monster_name = monster_name[:-4]
    file_name = copy.deepcopy(monster_name)
    file_name = monster_name[0].lower()+monster_name[1:]

    for letter in alphabet:
        file_name = file_name.replace(letter, "_"+letter.lower())
        monster_name = monster_name.replace(letter, " "+letter)

    preset_monster = [
        '[gd_resource type="Resource" load_steps=9 format=2]\n',
        '\n',
        '[ext_resource path="res://Assets/Monsters/monster_animations/'+filename+'" type="Texture" id=1]\n',
        '[ext_resource path="res://Scripts/Monster/BP_Monster.gd" type="Script" id=2]\n',
        '[ext_resource path="res://Assets/Monsters/statues/statue_'+filename+'" type="Texture" id=3]\n',
        '\n',
        '[sub_resource type="AtlasTexture" id=3]\n',
        'atlas = ExtResource( 1 )\n',
        'region = Rect2( 0, 0, 16, 16 )\n',
        '\n',
        '[sub_resource type="AtlasTexture" id=4]\n',
        'atlas = ExtResource( 1 )\n',
        'region = Rect2( 16, 0, 16, 16 )\n',
        '\n',
        '[sub_resource type="AtlasTexture" id=5]\n',
        'atlas = ExtResource( 1 )\n',
        'region = Rect2( 32, 0, 16, 16 )\n',
        '\n',
        '[sub_resource type="AtlasTexture" id=6]\n',
        'atlas = ExtResource( 1 )\n',
        'region = Rect2( 48, 0, 16, 16 )\n',
        '\n',
        '[sub_resource type="SpriteFrames" id=2]\n',
        'animations = [ {\n',
        '"frames": [ SubResource( 3 ), SubResource( 4 ), SubResource( 5 ), SubResource( 6 ) ],\n',
        '"loop": true,\n',
        '"name": "default",\n',
        '"speed": 5.0\n',
        '} ]\n',
        '\n',
        '[resource]\n',
        'script = ExtResource( 2 )\n',
        'monsterName = "'+monster_name+'"\n',
        'description = ""\n',
        'isBoss = false\n',
        'initiative = 0\n',
        'max_drop_amount = 1\n',
        'health = 80\n',
        'armor = 0\n',
        'damage = 10\n',
        'damage_type = ""\n',
        'attack_range = 1\n',
        'elemental_weakness0 = ""\n',
        'elemental_weakness1 = ""\n',
        'elemental_weakness2 = ""\n',
        'monsterAnimations = SubResource( 2 )\n',
        'characterPortrait = ExtResource( 3 )\n'
    ]

    f = open(savedir+"/"+file_name+".tres", "w")
    for line in preset_monster:
        f.write(line)
    f.close()
