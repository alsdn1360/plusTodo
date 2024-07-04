import 'package:flutter/material.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class HomeMatrix extends StatelessWidget {
  final List<TodoData> todoData;

  const HomeMatrix({
    super.key,
    required this.todoData,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(defaultPaddingS),
        decoration: BoxDecoration(
          color: darkWhite,
          borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        ),
        child: CustomPaint(
          size: const Size(
            double.infinity,
            double.infinity,
          ),
          painter: HomeMatrixPainter(
            todoData: todoData,
          ),
        ),
      ),
    );
  }
}

class HomeMatrixPainter extends CustomPainter {
  final List<TodoData> todoData;

  HomeMatrixPainter({required this.todoData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = black
      ..strokeWidth = 1;

    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    _drawArrow(canvas, Offset(size.width / 2, size.height), Offset(size.width / 2, 0), paint, isVertical: true);
    _drawArrow(canvas, Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint, isVertical: false);

    for (var todo in todoData) {
      final x = (todo.urgency / 10) * size.width;
      final y = size.height - (todo.importance / 10) * size.height;

      Color todoPointColor;
      if (todo.urgency >= 5 && todo.importance >= 5) {
        todoPointColor = red;
      } else if (todo.urgency >= 5 && todo.importance < 5) {
        todoPointColor = blue;
      } else if (todo.urgency < 5 && todo.importance >= 5) {
        todoPointColor = orange;
      } else {
        todoPointColor = green;
      }

      canvas.drawCircle(Offset(x, y), 5, Paint()..color = todoPointColor);
    }

    // 텍스트 그리기
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.text = TextSpan(text: 'Importance', style: CustomTextStyle.caption1);
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset((size.width / 2) - (textPainter.width + 8), 0),
    );

    textPainter.text = TextSpan(text: 'Urgency', style: CustomTextStyle.caption1);
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(size.width - (textPainter.width + 4), size.height / 2),
    );
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint, {required bool isVertical}) {
    const arrowSize = 8.0;
    final path = Path();

    path.moveTo(end.dx, end.dy);
    if (isVertical) {
      path.lineTo(end.dx - arrowSize / 2, end.dy + arrowSize / 2);
      path.lineTo(end.dx + arrowSize / 2, end.dy + arrowSize / 2);
    } else {
      path.lineTo(end.dx - arrowSize / 2, end.dy - arrowSize / 2);
      path.lineTo(end.dx - arrowSize / 2, end.dy + arrowSize / 2);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
