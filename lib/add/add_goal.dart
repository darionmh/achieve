import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:goald/add/reorderable_milestone_list.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/components/color_picker.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';
import 'package:intl/intl.dart';

class AddGoal extends StatefulWidget {
  final VoidCallback onFinish;

  const AddGoal({Key key, this.onFinish}) : super(key: key);

  @override
  _AddGoalState createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();
  DateFormat dateFormat = DateFormat('MM/dd/yyyy');

  var _title = '';
  var _description = '';
  var _endDate;
  var _endDateString = '';
  var _milestoneList = <Milestone>[];
  var _themeColor = primaryColor;

  var _titleError;
  var _endDateError;

  var isSaving = false;

  var _scrollController = ScrollController();

  void _save() {
    setState(
      () {
        _validateTitle();
        _validateDate();

        if (_titleError != null || _endDateError != null) return;

        isSaving = true;

        _goalService
            .add(
          Goal(
            title: _title,
            description: _description,
            endDate: _endDate,
            milestones: _milestoneList,
            theme: _themeColor,
          ),
        )
            .then(
          (_) {
            setState(() {
              widget.onFinish();
              isSaving = false;
            });
          },
        );
      },
    );
  }

  void _validateTitle() {
    setState(() {
      _titleError = null;

      if (_title == '') {
        _titleError = 'Title cannot be blank.';
      }
    });
  }

  void _validateDate() {
    setState(() {
      _endDateError = null;

      if (_endDateString == '') {
        _endDateError = 'You must select an end date.';
      }

      if (_endDateString != '') {
        try {
          _endDate = dateFormat.parse(_endDateString);
        } catch (e) {
          _endDateError = 'Date does not match format MM/DD/YYYY';
        }
      }
    });
  }

  TextEditingController dateController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 10 * 365)),
      lastDate: DateTime.now().add(Duration(days: 100 * 365)),
    );
    if (picked != null && picked != _endDate)
      setState(() {
        _endDate = picked;
        dateController.text = dateFormat.format(_endDate);
        _endDateString = dateController.text;
      });
  }

  void _handleColorSelect(Color color) {
    _themeColor = color;
  }

  Widget _buildAddMilestoneRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _milestoneList.add(Milestone());
          });
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        },
        child: Row(
          children: [
            Icon(Icons.add),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('Add milestone', style: accent_text_primary),
            ),
          ],
        ),
      ),
    );
  }

  void handleReorder(item, dir) {
    var oldIndex = _milestoneList.indexOf(item);
    var newIndex = oldIndex + dir;

    // print('search for $item, $oldIndex $newIndex');
    if (newIndex >= 0 && newIndex < _milestoneList.length) {
      print('swap $oldIndex $newIndex');

      setState(() {
        var a = _milestoneList[oldIndex];
        var b = _milestoneList[newIndex];

        _milestoneList[oldIndex] = b;
        _milestoneList[newIndex] = a;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25, bottom: 12),
          child: Text('Add goal', style: heading),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('Details', style: subheading),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TextField(
            decoration: InputDecoration(
              errorText: _titleError,
              labelText: 'Title',
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: primaryColor)),
            ),
            onChanged: (val) => _title = val,
            onEditingComplete: () => _validateTitle(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TextField(
            minLines: 5,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: primaryColor)),
            ),
            onChanged: (val) => _description = val,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: dateController,
            decoration: InputDecoration(
              errorText: _endDateError,
              labelText: 'End Date (MM/DD/YYYY)',
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: primaryColor)),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            onChanged: (val) => _endDateString = val,
            onEditingComplete: () => _validateDate(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8, top: 8),
          child: Text('Milestones', style: subheading),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(width: 1, color: primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: [
                ReorderableMilestoneList(
                  milestoneList: _milestoneList,
                  onReorder: handleReorder,
                  onUpdate: (i, val) {
                    print('updating $i');
                    setState(() => _milestoneList[i].description = val);
                  },
                  delete: (i) {
                    print('attemping to delete $i');
                    setState(() => _milestoneList.removeAt(i));
                  },
                ),
                _buildAddMilestoneRow(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 4, top: 8),
          child: Text('Goal theme', style: subheading),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: ColorPicker(
            initialColor: _themeColor,
            onChange: _handleColorSelect,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text(isSaving ? 'SAVING...' : 'SAVE'),
            onPressed: isSaving ? null : () => _save(),
          ),
        ),
        Container(
          child: ClickableText(
            margin: EdgeInsets.only(top: 10),
            text: 'CANCEL',
            onClick: () => widget.onFinish(),
          ),
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
