import 'package:flutter/material.dart';

class PaymentQrCode extends StatelessWidget {
  const PaymentQrCode({super.key, this.size = 190});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _QrCodePainter());
}

class _QrCodePainter extends CustomPainter {
  static const _modules = <String>[
    '111111100101101111111',
    '100000101110101000001',
    '101110101011101011101',
    '101110100100101011101',
    '101110101110101011101',
    '100000101011101000001',
    '111111101010101111111',
    '000000001101100000000',
    '110101111010111011010',
    '001110010111001101101',
    '111011101001111010011',
    '100101011111000110101',
    '011011110010111101010',
    '000000001111010011001',
    '111111101001111010101',
    '100000100111001111010',
    '101110101010111001101',
    '101110100011000110010',
    '101110101110111001111',
    '100000101001001010100',
    '111111101110111001011',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final moduleSize = size.width / _modules.length;
    final paint = Paint()..color = const Color(0xFF111827);
    for (var y = 0; y < _modules.length; y++) {
      for (var x = 0; x < _modules[y].length; x++) {
        if (_modules[y][x] == '1') {
          canvas.drawRect(
            Rect.fromLTWH(
              x * moduleSize,
              y * moduleSize,
              moduleSize + .2,
              moduleSize + .2,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
