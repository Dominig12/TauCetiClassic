/// A wrapper for _create_spawners that allows us to pretend we're using normal named arguments
#define create_spawners(type, num, arguments...) _create_spawners(type, num, list(##arguments))

<<<<<<< HEAD
#define create_spawner(type, arguments...) create_spawners(type, 1, ##arguments)
=======
#define create_spawner(type, arguments...) _create_spawners(type, 1, list(##arguments))
>>>>>>> ee76559633a855f85b6ae3666a190bbdca4d9c8d
