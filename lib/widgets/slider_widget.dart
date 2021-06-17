import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;
  final void Function(double) onChanged;
 final double value;

  SliderWidget(
      {this.sliderHeight = 48,
        this.max = 10,
        this.min = 0,
        this.fullWidth = false,
     required this.onChanged,
        required this.value,
      });



  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.fullWidth) paddingFactor = .3;

    return Container(
      width: this.fullWidth
          ? double.infinity
          : (this.sliderHeight) * 5.5,
      height: (this.sliderHeight),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((this.sliderHeight * .3)),
        ),
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF00c6ff),
              const Color(0xFF0072ff),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.sliderHeight * paddingFactor,
            2, this.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '${this.min}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,

              ),
            ),
            SizedBox(
              width: this.sliderHeight * .1,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(.5),

                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: this.sliderHeight * .4,
                      min: this.min,
                      max: this.max,
                    ),
                    overlayColor: Colors.white.withOpacity(.4),
                    //valueIndicatorColor: Colors.white,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                  ),
                  child: Slider(
                      value: value,
                      onChanged: onChanged
                  ),
                ),
              ),
            ),
            SizedBox(
              width: this.sliderHeight * .1,
            ),
            Text(
              '${this.max}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double>? activationAnimation,
        Animation<double>? enableAnimation,
        bool? isDiscrete,
        TextPainter? labelPainter,
        RenderBox? parentBox,
        SliderThemeData? sliderTheme,
        TextDirection? textDirection,
        double? value,
        double? textScaleFactor,
        Size? sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: sliderTheme?.thumbColor, //Text Color of Value on Thumb
      ),
      text: getValue(value ?? 0),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
    Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min+(max-min)*value).round().toString();
  }
}


class CustomSliderThumbRect extends SliderComponentShape {
  final double? thumbRadius;
  final thumbHeight;
  final int? min;
  final int? max;

  const CustomSliderThumbRect({
    this.thumbRadius,
    this.thumbHeight,
    this.min,
    this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius ?? 0);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double>? activationAnimation,
        Animation<double>? enableAnimation,
        bool? isDiscrete,
        TextPainter? labelPainter,
        RenderBox? parentBox,
        SliderThemeData? sliderTheme,
        TextDirection? textDirection,
        double? value,
        double? textScaleFactor,
        Size? sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbHeight * 1.2, height: thumbHeight * .6),
      Radius.circular(thumbRadius??0 * .4),
    );

    final paint = Paint()
      ..color = sliderTheme?.activeTrackColor ?? Colors.blue //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: thumbHeight * .3,
            fontWeight: FontWeight.w700,
            color: sliderTheme?.thumbColor,
            height: 1),
        text: '${getValue(value??0)}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
    Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min!+(max!-min!.toInt())*value).round().toString();
  }
}