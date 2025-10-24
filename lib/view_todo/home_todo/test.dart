import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.check_circle_rounded),
        Text('할 일 완료', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.star_rounded),
        Text('할 일 즐겨찾기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}