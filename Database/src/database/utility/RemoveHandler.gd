extends Node


func delete_directory(directory_path: String) -> bool:
	var dir = DirAccess.open(directory_path)
	if dir != null:
		if dir.list_dir_begin():  # Beginne die Auflistung der Dateien im Verzeichnis
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					# Wenn es ein Verzeichnis ist, rufe die Funktion rekursiv auf
					if not delete_directory(directory_path + "/" + file_name):
						return false
				else:
					# Lösche die Datei
					if dir.remove(directory_path + "/" + file_name) != OK:
						print("Failed to delete file: ", file_name)
						return false
				file_name = dir.get_next()
			dir.list_dir_end()  # Beende die Auflistung
			dir.remove(directory_path)  # Lösche das Verzeichnis selbst
			print("Directory deleted successfully: ", directory_path)
			return true
		else:
			print("Failed to list directory: ", directory_path)
	else:
		print("Directory does not exist: ", directory_path)
	return false

func delete_file(file_path: String) -> bool:
	var dir = DirAccess.open("user://")
	if dir.file_exists(file_path):
		var err = dir.remove(file_path)
		if err == OK:
			print("File deleted successfully: ", file_path)
			return true
		else:
			print("Failed to delete file: ", file_path)
			return false
	else:
		print("File does not exist: ", file_path)
		return false
