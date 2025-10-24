import 'package:flutter/material.dart';
import 'package:tasks/core/app_theme.dart';
import 'package:tasks/core/ttotoy_entity.dart';

class AddToDoDialog extends StatefulWidget {
  const AddToDoDialog({super.key});

  @override
  State<AddToDoDialog> createState() => _AddToDoDialogState();
}

class _AddToDoDialogState extends State<AddToDoDialog> {
  bool isFavorite = false;
  bool isDescriptionActivated = false;
  final _focusNode = FocusNode();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  void saveToDo() {
    final title = _controller1.text.trim();
    final description = _controller2.text.trim().isEmpty
        ? null
        : _controller2.text.trim();
    if (title.isNotEmpty) {
      final result = ToDoEntity(
        title: title,
        description: description,
        isFavorite: isFavorite,
      );
      Navigator.of(context).pop(result);
    } else {
      // _focusNode.requestFocus();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('할 일을 입력해주세요.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 15),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _focusNode.dispose(); // ✅ 중요: FocusNode 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: vrc(context).background100,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '새 할 일',
                hintStyle: TextStyle(
                  color: vrc(context).textColor100,
                  fontSize: 16,
                ),
              ),
              style: TextStyle(color: vrc(context).textColor200, fontSize: 16),
              maxLines: 1,
              autofocus: true,
              focusNode: _focusNode,
              keyboardType: TextInputType.text,
              onSubmitted: (value) => saveToDo(),
              onChanged: (value) => setState(() {}),
            ),
            if (isDescriptionActivated)
              Expanded(
                child: TextField(
                  controller: _controller2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '세부정보 추가',
                  ),
                  maxLines: null, // 엔터로 줄바꿈 허용
                  keyboardType: TextInputType.multiline,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      if (!isDescriptionActivated)
                        InkWell(
                          onTap: () => setState(() {
                            isDescriptionActivated = !isDescriptionActivated;
                          }),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Icon(Icons.short_text_rounded, size: 24),
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () => setState(() {
                          isFavorite = !isFavorite;
                        }),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Icon(
                              isFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => saveToDo(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Text(
                        '저장',
                        style: TextStyle(
                          color: _controller1.text.trim().isNotEmpty
                              ? vrc(context).textColor200
                              : vrc(context).textColor100,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
