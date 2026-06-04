import 'package:flutter/material.dart';

class VibeLogo extends StatelessWidget {
  final double height;
  const VibeLogo({super.key, this.height = 60});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Símbolo VP ondulado
          CustomPaint(
            size: Size(height * 0.8, height),
            painter: _VibePainter(),
          ),
          const SizedBox(width: 8),
          // Texto "vibe"
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF9B59F5)],
                ).createShader(bounds),
                child: Text(
                  'vibe',
                  style: TextStyle(
                    fontSize: height * 0.55,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                'rede social',
                style: TextStyle(
                  fontSize: height * 0.2,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VibePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round;

    // Gradiente laranja-rosa-roxo
    paint.shader = const LinearGradient(
      colors: [
        Color(0xFFFF6B00),
        Color(0xFFFF3C7E),
        Color(0xFF7B2FF7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    // Onda "V" seguida de "P"
    path.moveTo(0, size.height * 0.5);
    path.cubicTo(
      size.width * 0.15, size.height * 0.8,
      size.width * 0.25, size.height * 0.8,
      size.width * 0.35, size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.45, size.height * 0.2,
      size.width * 0.55, size.height * 0.1,
      size.width * 0.65, size.height * 0.3,
    );
    path.cubicTo(
      size.width * 0.75, size.height * 0.5,
      size.width * 0.75, size.height * 0.7,
      size.width * 0.65, size.height * 0.8,
    );
    path.cubicTo(
      size.width * 0.55, size.height * 0.9,
      size.width * 0.45, size.height * 0.7,
      size.width * 0.55, size.height * 0.5,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
