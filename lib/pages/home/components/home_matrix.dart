import 'package:flutter/material.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class HomeMatrix extends StatelessWidget {
  final List<Todo> todoData;

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
          color: white,
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
  final List<Todo> todoData;

  HomeMatrixPainter({required this.todoData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = black
      ..strokeWidth = 1;

    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    final thinPaint = Paint()
      ..color = black.withOpacity(0.2)
      ..strokeWidth = 0.5;

    for (int i = 1; i < 10; i++) {
      final x = (i / 10) * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), thinPaint);
    }

    for (int i = 1; i < 10; i++) {
      final y = (i / 10) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), thinPaint);
    }

    _drawArrow(canvas, Offset(size.width / 2, size.height), Offset(size.width / 2, 0), paint, isVertical: true);
    _drawArrow(canvas, Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint, isVertical: false);

    Map<String, int> pointCount = {};
    for (var todo in todoData) {
      final x = (todo.urgency / 10) * size.width;
      final y = size.height - (todo.importance / 10) * size.height;

      final pointKey = '$x,$y';
      pointCount[pointKey] = (pointCount[pointKey] ?? 0) + 1;
    }

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

      canvas.drawCircle(Offset(x, y), 6, Paint()..color = todoPointColor);

      final textDuplicationPointPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      final pointKey = '$x,$y';
      if (pointCount[pointKey] != null && pointCount[pointKey]! > 1) {
        textDuplicationPointPainter.text = TextSpan(text: '${pointCount[pointKey]}', style: CustomTextStyle.caption1);
        textDuplicationPointPainter.layout(minWidth: 0, maxWidth: size.width);
        textDuplicationPointPainter.paint(canvas, Offset(x - 3, y - 22));
        pointCount.remove(pointKey);
      }
    }

    final textIntroducePainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textIntroducePainter.text = TextSpan(text: '중요도', style: CustomTextStyle.caption1);
    textIntroducePainter.layout(minWidth: 0, maxWidth: size.width);
    textIntroducePainter.paint(
      canvas,
      Offset((size.width / 2) - (textIntroducePainter.width + 6), 2),
    );

    textIntroducePainter.text = TextSpan(text: '긴급도', style: CustomTextStyle.caption1);
    textIntroducePainter.layout(minWidth: 0, maxWidth: size.width);
    textIntroducePainter.paint(
      canvas,
      Offset(size.width - (textIntroducePainter.width + 6), (size.height / 2) + 4),
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
