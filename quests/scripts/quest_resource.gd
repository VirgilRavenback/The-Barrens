class_name Quest extends Resource

#This resource will describe the quest and its rewards
#It will not track quest progression

@export var title : String
@export_multiline var description : String

@export var steps : Array[ String ]

@export var reward_xp : int 
@export var reward_items : Array[ QuestRewardItem ] = []
