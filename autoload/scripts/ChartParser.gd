extends Node

func loadSong(type:String, song:String, diff:String = "normal"):
	match type:
		"VANILLA":
			var json = CoolUtil.load_json(Paths.chart_json(song, diff)).song
			if !"stage" in json || json.stage == "stage": json.stage = "stage"
			
			var key_amount:int = 4
			var gf_version:String = "gf"
			if "player3" in json: gf_version = json.player3
			if "gfVersion" in json: gf_version = json.gfVersion
			if "gf" in json: gf_version = json.gf
			if "keyCount" in json: key_amount = json.keyCount
			if "keyNumber" in json: key_amount = json.keyNumber
			if "mania" in json:
				match json.mania:
					1: key_amount = 6
					2: key_amount = 7
					3: key_amount = 9
					_: key_amount = 4
			
			var songData:Song = Song.new()
			songData.name = json.song
			songData.bpm = json.bpm
			songData.scroll_speed = json.speed
			songData.sections = []
			songData.events = []
			songData.needs_voices = json.needsVoices
			songData.key_amount = key_amount
			songData.dad = json.player2
			songData.gf = gf_version
			songData.bf = json.player1
			songData.stage = json.stage
			
			for section in json.notes:
				var cool_sex:Section = Section.new() 
				cool_sex.notes = []
				cool_sex.player_section = section.mustHitSection
				cool_sex.alt_anim = section.altAnim if "altAnim" in section else false
				cool_sex.bpm = section.bpm if "bpm" in section else 0.0
				cool_sex.change_bpm = section.changeBPM if "changeBPM" in section else false
				cool_sex.length_in_steps = section.lengthInSteps
				
				for note in section.sectionNotes:
					var alt_anim:bool = section.altAnim if "altAnim" in section else false
					if range(note.size()).has(3) && note[3]:
						alt_anim = note[3]
					
					var cool_sex_note:SectionNote = SectionNote.new()
					cool_sex_note.strum_time = note[0]
					cool_sex_note.direction = int(note[1])
					cool_sex_note.sustain_length = note[2]
					cool_sex_note.alt_anim = alt_anim
					cool_sex_note.type = "Default"
					cool_sex.notes.append(cool_sex_note)
					
				songData.sections.append(cool_sex)
				
			return songData
			
		"PSYCH":
			print("psych?!?!?!!?!??!")
			
		_:
			var json = CoolUtil.load_json(Paths.chart_json(song, diff)).song
			
			var songData:Song = Song.new()
			songData.name = json.name
			songData.bpm = json.bpm
			songData.scroll_speed = json.scrollSpeed
			songData.sections = []
			songData.events = []
			songData.needs_voices = json.needsVoices
			songData.key_amount = json.keyAmount
			songData.dad = json.dad
			songData.gf = json.gf
			songData.bf = json.bf
			songData.stage = json.stage
			
			for section in json.sections:
				var cool_sex:Section = Section.new() 
				cool_sex.notes = []
				cool_sex.player_section = section.playerSection
				cool_sex.alt_anim = section.altAnim if "altAnim" in section else false
				cool_sex.bpm = section.bpm if "bpm" in section else 0.0
				cool_sex.change_bpm = section.changeBPM if "changeBPM" in section else false
				cool_sex.length_in_steps = section.lengthInSteps
				
				for note in section.notes:
					var alt_anim:bool = section.altAnim if "altAnim" in section else false
					if range(note.size()).has(3) && note[3] is bool && note[3]:
						alt_anim = note[3]
					
					var cool_sex_note:SectionNote = SectionNote.new()
					cool_sex_note.strum_time = note[0]
					cool_sex_note.direction = int(note[1])
					cool_sex_note.sustain_length = note[2]
					cool_sex_note.alt_anim = alt_anim
					cool_sex_note.type = note[3] if range(note.size()).has(3) && note[3] is String else "Default"
					cool_sex.notes.append(cool_sex_note)
					
				songData.sections.append(cool_sex)
				
			return songData
			
	var default_return:Song = Song.new()
	return default_return
