class_name PlaylistGameManager extends MinigameBase

#region song list
var random_song_list := ["La Marimorena", "Los hippos no mienten", "¿Qué va a ser de mi?", "Barquito de cáscara de nuez", "Pies para que os quiero", "Fiesta marrana", "Zapatos", "Macarrones con tomate", "Tulipanes", 
"Cadenas del amor", "Amor que dormía", "Oscuro recuerdo", "Tristeza abatida", "Tu serás mi luz siempre", "Los Villanos", "En llamas", "Un perro en tu tejado", "Tierras lejanas a mi hogar", "Todo el día en la calle", 
"Naranja y sal", "Tenía tanto que expropiarte", "Días de Invierno", "Simple y Limpio", "Santuario", "Quieto todo el mundo", "Las bizarras desventuras de Jonhatan Joestar", "Hay un mosquito en tu ventana",
"Rojo fuego y Verde Hoja", "Por la boca muere el pez", "El universo debajo de mí", "Ave Juanjito", "Todo fue un error", "¿A quién no le va a gustar?", "El diablo", "El Mosca Go Global", "Hazte con todos", 
"Lorem Ipsum Dolor Sit Amet", "Platino Puro", "Rubí y Zafiro", "Perla y Diamante", "Blanco y Negro", "Sol y Luna", "La esperanza cabalga sola", "La montaña", "El caldo de la abuela", "La torre batalla", 
"Canción de la Curación", "Mundo Misterioso", "Rio Lunar", "Llévame a la luna", "El retorno del rey", "Hombre niño en paris", "El paraíso del ritmo", "Sinsentido e Insensibilidad", "Orgullosas y Prejuiciosas", 
"El extranjero", "Prenderse fuego ante el olvido", "Caminar de puntillas sobre la ansiedad", "Fingir demencia contra la perdición", "Los hermanos de Jonas", "El bucle", "Señales en la lluvia", "Noches blancas"]
#endregion

#region labels & images
@onready var time_left_label: Label = $UI/CurrentMusicUI/NextSongInLabel/TimeLeftLabel
@onready var next_song_label : Array[Label] = [$UI/NextSongUI/IMG_NextSong1/NextSongLabel1, $UI/NextSongUI/IMG_NextSong2/NextSongLabel2, $UI/NextSongUI/IMG_NextSong3/NextSongLabel3, 
$UI/NextSongUI/IMG_NextSong4/NextSongLabel4, $UI/NextSongUI/IMG_NextSong5/NextSongLabel5, $UI/NextSongUI/IMG_NextSong6/NextSongLabel6, $UI/NextSongUI/IMG_NextSong7/NextSongLabel7]
@onready var next_song_image : Array[TextureRect] = [$UI/NextSongUI/IMG_NextSong1, $UI/NextSongUI/IMG_NextSong2, $UI/NextSongUI/IMG_NextSong3, $UI/NextSongUI/IMG_NextSong4,
 $UI/NextSongUI/IMG_NextSong5, $UI/NextSongUI/IMG_NextSong6, $UI/NextSongUI/IMG_NextSong7]
@onready var button_image : Array[TextureRect] = [$UI/PhonesUI/Player1_Phone/ButtonPhone1, $UI/PhonesUI/Player2_Phone/ButtonPhone2, $UI/PhonesUI/Player3_Phone/ButtonPhone3, $UI/PhonesUI/Player4_Phone/ButtonPhone4]
#endregion


# lista de la siguiente canción
var next_song_list : Array[String] = ["", "", "", "", "", "", "", ""]
# lista de posibles canciones
var player_song_list : Array[String] = []
# lista de jugadores
var player_list : Array[int] = []
var player_color_list : Array[Color] = [Color(0.00, 0.61, 0.45, 1), Color(0.94, 0.89, 0.25, 1), Color(0.80, 0.47, 0.65, 1), Color(0.83, 0.36, 0, 1)]

# lo que le queda a la siguiente canción
@onready var song_timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $UI/FingersUI/AnimationPlayer

var song_times := [6, 7, 8, 9]
var song_modes := ["slow", "fast", "normal"]
	
func _process(float) -> void:
	time_left_label.text = str(int(song_timer.time_left))

func OnMinigameStarted() -> void:
	SetUp()
	
func GameEnded(winner:int)-> void:
	ScoreManager.AddVictoryToPlayer(winner)
	#Hace que no pueda recibir más input el minijuego
	StopMinigame()
	await get_tree().create_timer(2).timeout
	TransitionToNextMinigame()

func OnPlayerPressed(playerId: int) -> void:
	if(button_image[playerId].visible == true):
		# animación de jugador pulsando el móvil
		animation_player.play("Player"+str(playerId + 1))
		# aunmentar tiempo de espera del jugador para pulsar de nuevo

#region OnPlayerAnimationEnd

func onPlayer1AnimationEnd():
	button_image[0].visible=false
	player_list.push_front(0)
	next_song_list.push_front(player_song_list[0])
	next_song_list.pop_back()
	UpdateNextSongLabel(0)
	
func onPlayer2AnimationEnd():
	button_image[1].visible=false
	player_list.push_front(1)
	next_song_list.push_front(player_song_list[1])
	next_song_list.pop_back()
	UpdateNextSongLabel(1)

func onPlayer3AnimationEnd():
	button_image[2].visible=false
	player_list.push_front(2)
	next_song_list.push_front(player_song_list[2])
	next_song_list.pop_back()
	UpdateNextSongLabel(2)

func onPlayer4AnimationEnd():
	button_image[3].visible=false
	player_list.push_front(3)
	next_song_list.push_front(player_song_list[3])
	next_song_list.pop_back()
	UpdateNextSongLabel(3)
#endregion

func SetUp() -> void:
#region player set up
	player_list = PlayersController.GetCurrentPlayersIds()
	var player_count := player_list.size()
	var pos:int = 0
	for player_id in player_list:
		var player_name := PlayersController.GetPlayerNickName(player_id)
		if player_name == "": player_name == "J" + str(player_id + 1)
		#activar movil del jugador en la interfaz
		player_song_list.push_back(player_name + " - " + random_song_list.pop_at(randi_range(0, random_song_list.size()-1)))
		pos += 1
#endregion
	
	song_timer.start(song_times[randi_range(0, song_times.size()-1)])


func UpdateNextSongLabel(playerId: int) -> void:
	var pos:int = 0
	var last_color:Color
	var aux_color:Color
	for label in next_song_label:
		# Cambiamos el color 
		if(pos == 0):
			last_color = next_song_image[0].modulate
			next_song_image[0].modulate = player_color_list[playerId]
		else:
			aux_color = next_song_image[pos].modulate
			next_song_image[pos].modulate = last_color
			last_color = aux_color

		# Cambiamos el texto
		if(next_song_list[pos] != ""):
			next_song_image[pos].visible = true
			label.text = str(pos+1) + ". " + next_song_list[pos]
		pos += 1

func _on_timer_timeout() -> void:
	GameEnded(player_list.front())
