import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiaryCardSlider extends StatefulWidget {
  double initSliderValue;
  String sliderText;
  double fontSize;
  ValueChanged<double> onChanged;
  DiaryCardSlider({Key? key, required this.sliderText, required this.initSliderValue, required this.onChanged, this.fontSize = 14}) : super(key: key);
  @override
  _DiaryCardSliderState createState() => _DiaryCardSliderState();
}

class _DiaryCardSliderState extends State<DiaryCardSlider> {
  double? _sliderValue;
  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initSliderValue;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.sliderText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: Color(0xFF333F49),
        ),
          ),
        Slider(
          value: widget.initSliderValue,
          min: 0,
          max: 100,
          divisions: 20,
          label: widget.initSliderValue.round().toString(),
          onChanged: (double value){
            setState(() {
              widget.initSliderValue = value;
            });
            widget.onChanged(value);
          },
        )
      ],
    );
  }

}


