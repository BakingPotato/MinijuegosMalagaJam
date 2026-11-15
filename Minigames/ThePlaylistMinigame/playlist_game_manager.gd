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

#region labels
@onready var time_left_label: Label = $UI/CurrentMusicUI/NextSongInLabel/TimeLeftLabel
@onready var next_song_label : Array[Label] = [$UI/NextSongUI/NextSongLabel1, $UI/NextSongUI/NextSongLabel2, $UI/NextSongUI/NextSongLabel3, $UI/NextSongUI/NextSongLabel4, $UI/NextSongUI/NextSongLabel5, 
$UI/NextSongUI/NextSongLabel6, $UI/NextSongUI/NextSongLabel7, $UI/NextSongUI/NextSongLabel8, $UI/NextSongUI/NextSongLabel9]
#endregion


# lista de la siguiente canción
var next_song_list : Array[String] = ["", "", "", "", "", "", "", "", ""]
# lista de posibles canciones
var player_song_list : Array[String] = []
# lista de jugadores
var player_list : Array[int] = []

# lo que le queda a la siguiente canción
@onready var song_timer: Timer = $Timer
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
	# animación de jugador pulsando el móvil
	# aunmentar tiempo de espera del jugador para pulsar de nuevo
	player_list.push_front(playerId)
	next_song_list.push_front(player_song_list[playerId])
	next_song_list.pop_back()
	
	UpdateNextSongLabel()

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
	

func UpdateNextSongLabel() -> void:
	var pos:int = 0
	for label in next_song_label:
		label.text = next_song_list[pos]
		pos += 1

func _on_timer_timeout() -> void:
	GameEnded(player_list.front())
