extends MarginContainer


onready var CardDatabase = preload("res://assets/Cards/CardDatabase.gd")
var Cardname = 'A'
onready var CardInfo = CardDatabase.DATA[CardDatabase.get(Cardname)]
var startpos = Vector2()
var targetpos = Vector2()
var focuspos = Vector2()
var startrot = 0
var targetrot = 0
var t = 0
var drawtime = 0.3
var organizetime = 0.5
var Tweening = false
onready var Orig_scale = rect_scale*2

var setup = true
var startscale = Vector2()
var Cardpos = Vector2()
var ZoomSize = 1.5
var ZoomTime = 0.05
var ReorganizeNeighbours = true
var NumberCardsHand = 0
var Card_Numb = 0
var NeighbourCard
var Move_Neightbour_Card_Check = false

enum {
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganizeHand
}
var state = InHand

func _ready():
	var CardSize = rect_size
	rect_position = Vector2(-500,-500)
	rect_scale *= CardSize/$Card.texture.get_size()*1.8
	$Focus.rect_scale *= CardSize/$Focus.rect_size*2
	
	var Damage = str(CardInfo[0])
	var Word = str(CardInfo[1])
	var Draw = str(CardInfo[2])
	var Description = CardInfo[3]
	$Bar/TopBar/Damage/HBoxContainer/Damage.text = Damage
	$Bar/MidBar/CardName/HBoxContainer/CardName.text = Cardname
	$Bar/MidBar2/Description/CenterContainer/Description.text = Description
	$Bar/BotBar/Word/HBoxContainer/Word.text = Word
	$Bar/BotBar/Draw/HBoxContainer/Draw.text = Draw
	
func _physics_process(delta):
	match state:
		InHand:
			pass
		InPlay:
			pass
		InMouse:
			pass
		FocusInHand:
			raise()
			focuspos = targetpos
			focuspos.y = 580
			if setup:
				Setup()
			if t<=1:
				rect_position = startpos.linear_interpolate(focuspos, t)
				rect_rotation = startrot * (1-t) + 0*t
				rect_scale = startscale * (1-t) + Orig_scale*ZoomSize*t
				t += delta/float(ZoomTime)
				if ReorganizeNeighbours:
					ReorganizeNeighbours = false
					NumberCardsHand = $'../../'.NumberCardsHand - 1
					if Card_Numb - 1 >= 0:
						Move_Neighbour_Card(Card_Numb - 1,true,1)
					if Card_Numb - 2 >= 0:
						Move_Neighbour_Card(Card_Numb - 2,true,0.25)
					if Card_Numb + 1 <= NumberCardsHand:
						Move_Neighbour_Card(Card_Numb + 1,false,1)
					if Card_Numb + 2 <= NumberCardsHand:
						Move_Neighbour_Card(Card_Numb + 2,false,0.25)
			else:
				rect_position = focuspos
				rect_rotation = 0
				rect_scale = Orig_scale*ZoomSize
		MoveDrawnCardToHand: 
			if t <= 1: 
				if Tweening == false:
					$Tween.interpolate_property($'.','rect_position',startpos,
					targetpos,drawtime,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
					$Tween.start()
					Tweening = true
				rect_rotation = startrot * (1-t) + targetrot*t
				t += delta/float(drawtime)
			else:
				rect_position = targetpos
				rect_rotation = targetrot
				state = InHand
				t = 0
		ReOrganizeHand:
			if setup:
				Setup()
			if t <= 1: # Always be a 1
				if Move_Neightbour_Card_Check:
					Move_Neightbour_Card_Check = false
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(organizetime)
				if ReorganizeNeighbours == false:
					ReorganizeNeighbours = true
					if Card_Numb - 1 >= 0:
						Reset_Card(Card_Numb - 1)
					if Card_Numb - 2 >= 0:
						Reset_Card(Card_Numb - 2)
					if Card_Numb + 1 <= NumberCardsHand:
						Reset_Card(Card_Numb + 1)
					if Card_Numb + 2 <= NumberCardsHand:
						Reset_Card(Card_Numb + 2)
			else:
				rect_position = targetpos
				rect_rotation = targetrot
				rect_scale = Orig_scale
				state = InHand
				
func Move_Neighbour_Card(CardNumb,Left,Spreadfactor):
	NeighbourCard = $'../'.get_child(CardNumb)
	if Left:
		NeighbourCard.targetpos = NeighbourCard.Cardpos - Spreadfactor*Vector2(65,0)
	else:
		NeighbourCard.targetpos = NeighbourCard.Cardpos + Spreadfactor*Vector2(65,0)
	NeighbourCard.setup = true
	NeighbourCard.state = ReOrganizeHand
	NeighbourCard.Move_Neightbour_Card_Check = true
	
func Reset_Card(CardNumb):
	if NeighbourCard.Move_Neightbour_Card_Check == false:
		NeighbourCard = $'../'.get_child(CardNumb)
		if NeighbourCard.state != FocusInHand:
			NeighbourCard.state = ReOrganizeHand
			NeighbourCard.targetpos = NeighbourCard.Cardpos
			NeighbourCard.setup = true

func Setup():
	if setup:
		startpos = rect_position
		startrot = rect_rotation
		startscale = rect_scale
		t = 0
		setup = false

func _on_Focus_mouse_entered():
	match state:
		InHand, ReOrganizeHand:
			state = FocusInHand
func _on_Focus_mouse_exited():
	match state:
		FocusInHand:
			state = ReOrganizeHand
