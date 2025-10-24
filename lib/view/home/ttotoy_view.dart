import 'package:flutter/material.dart';
import 'package:tasks/core/app_theme.dart';
import 'package:tasks/core/ttotoy_entity.dart';
import 'package:tasks/view/ttotoy_detail/ttotoy_detail_page.dart';

class ToDoView extends StatelessWidget {
  const ToDoView({
    super.key,
    required this.toDo,
    required this.onToggleFavorite,
    required this.onToggleDone,
  });
  final ToDoEntity toDo;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: vrc(context).background200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 12,
        children: [
          InkWell(
            onTap: onToggleDone,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(
                  toDo.isDone
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToDoDetailPage(
                    toDo: toDo,
                    onToggleFavorite: onToggleFavorite,
                  ),
                ),
              ),
              child: Text(
                toDo.title,
                style: TextStyle(
                  color: vrc(context).textColor200,
                  fontSize: 16,
                  decoration: toDo.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onToggleFavorite,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(
                  toDo.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
