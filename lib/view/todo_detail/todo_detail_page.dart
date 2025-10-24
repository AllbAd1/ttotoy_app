import 'package:flutter/material.dart';
import 'package:tasks/core/app_theme.dart';
import 'package:tasks/core/ttotoy_entity.dart';

class ToDoDetailPage extends StatefulWidget {
  const ToDoDetailPage({
    super.key,
    required this.toDo,
    required this.onToggleFavorite,
  });
  final ToDoEntity toDo;
  final VoidCallback onToggleFavorite;

  @override
  State<ToDoDetailPage> createState() => _ToDoDetailPageState();
}

class _ToDoDetailPageState extends State<ToDoDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.toDo.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: vrc(context).background300,
      appBar: AppBar(
        backgroundColor: vrc(context).background200,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              widget.onToggleFavorite();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 48,
              height: 48,
              child: Center(
                child: Icon(
                  _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 24,
                  color: vrc(context).textColor200,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: vrc(context).background300,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              widget.toDo.title,
              style: TextStyle(
                color: vrc(context).textColor200,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Icon(
                  Icons.short_text_rounded,
                  size: 24,
                  color: vrc(context).textColor200,
                ),
                Expanded(
                  child: Text(
                    widget.toDo.description ?? '세부정보 추가',
                    style: TextStyle(
                      color: vrc(context).textColor200,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}