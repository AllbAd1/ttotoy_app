import 'package:flutter/material.dart';
import 'package:tasks/core/app_theme.dart';

class NoToDo extends StatelessWidget {
  const NoToDo({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: vrc(context).background200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Image.asset('assets/images/no_todo.webp', width: 100, height: 100),
          Text(
            '아직 할 일이 없음',
            style: TextStyle(
              color: vrc(context).textColor100,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '할 일을 추가하고 $title에서\n할 일을 추적하세요.',
            style: TextStyle(
              color: vrc(context).textColor100,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
