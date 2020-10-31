import 'package:flutter/material.dart';
import 'package:goald/styles.dart';

class ColorPicker extends StatefulWidget {

  Color initialColor;
  Function(Color) onChange;

  ColorPicker({@required this.onChange, this.initialColor = primaryColor});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int _selected = 0;
  List<Color> _colors = <Color>[];

  void initState() {
    _colors.addAll(color_options);

    _selected = _colors.indexOf(widget.initialColor);
    if(_selected < 0) {
      _selected = 0;
      _colors.insert(0, widget.initialColor);
    }

    super.initState();
  }

  void _handleSelect(i) {
    setState(() => _selected = i);
    widget.onChange(_colors[i]);
  }
  
  Widget _buildSelector(Color color, int i) {
    return GestureDetector(
      child: Icon(
        i == _selected ? Icons.radio_button_checked : Icons.fiber_manual_record,
        size: 50,
        color: color,
      ),
      onTap: () => _handleSelect(i),
    );
  }

  List<Widget> _buildColors() {
    var selectors = <Widget>[];

    var i=0;
    for (var value in _colors) {
      selectors.add(_buildSelector(value, i++));
    }

    return selectors;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildColors()
    );
  }
}
