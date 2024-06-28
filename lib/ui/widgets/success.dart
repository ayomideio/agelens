import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/constants/index.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(),
      child: Container(
          width: 150,
          height: 150,
          child: Center(
            child: Image.asset(
              'assets/vectors/check-mark.png',
              height: 30,
            ),
          )),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final middleRadius = outerRadius * 0.7;
    final innerRadius = middleRadius * 0.7;
    final outerPaint = Paint()
      ..color = ColorStyles.primaryButtonColor
      ..style = PaintingStyle.stroke;
    final middlePaint = Paint()
      ..color = ColorStyles.primaryButtonColor
      ..style = PaintingStyle.stroke;
    final innerPaint = Paint()
      ..color = ColorStyles.primaryButtonColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, outerRadius, outerPaint);
    canvas.drawCircle(center, middleRadius, middlePaint);
    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
