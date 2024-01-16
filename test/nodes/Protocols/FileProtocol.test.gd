class_name FileProtocolTest extends ClassTest

func run():
	instance = FileProtocol.new()

	instance.file_name_scheme = '{hash}-{id}-{year}-{month}-{day}-{weekday}-{hour}-{minute}-{second}.json'

	# create temporary directory
	instance.target_dir = '/tmp/godot-FileProtocol-test'
	DirAccess.make_dir_absolute(instance.target_dir)
	var i = 1
	while (!DirAccess.dir_exists_absolute(instance.target_dir)):
		instance.target_dir = '/tmp/godot-FileProtocol-test' + i
		DirAccess.make_dir_absolute(instance.target_dir)
		i += 1

	var format_dict = {
		hash = {}.hash(),
		id = 1
	}
	format_dict.merge(Time.get_date_dict_from_system())
	format_dict.merge(Time.get_time_dict_from_system())
	compare(
		instance.generate_file_name({}),
		instance.file_name_scheme.format(format_dict),
		'generate file name'
	)
