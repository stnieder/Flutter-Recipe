import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class BubbleIndicator extends Decoration{
  final double indicatorHeight;
  final double indicatorWidth;
  final Color indicatorColor;

  const BubbleIndicator({
    this.indicatorColor: Colors.blueAccent,
    this.indicatorHeight: 20.0,
    this.indicatorWidth: 25.0
  }) : assert(indicatorHeight != null);

  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) {
    return new _CustomPainter(this, onChanged);
  }

}

class _CustomPainter extends BoxPainter{
  final BubbleIndicator decoration;
  double get indicatorHeight => decoration.indicatorHeight;
  double get indicatorWidth => decoration.indicatorWidth;
  Color get indicatorColor => decoration.indicatorColor;

  _CustomPainter(this.decoration, VoidCallback onChanged)
    : assert(decoration != null),
      super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration){
    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = Offset(offset.dx, (configuration.size.height/2) - indicatorHeight/2) & Size(configuration.size.width, indicatorWidth);
    final Paint paint = Paint();
    paint.color = indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(10.0)), paint);
  }
}