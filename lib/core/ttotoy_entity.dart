class ToDoEntity {
  ToDoEntity({
    required this.title,
    required this.description,
    required this.isFavorite,
    this.isDone = false,
  });
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;

}
