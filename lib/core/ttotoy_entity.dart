class ToDoEntity { // 할 일 엔티티
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
