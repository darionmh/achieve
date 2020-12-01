import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:goald/add/reorderable_milestone_list.dart';
import 'package:goald/components/are_you_sure.dart';
import 'package:goald/components/clickable_text.dart';
import 'package:goald/components/color_picker.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';
import 'package:intl/intl.dart';

class EditGoal extends StatefulWidget {
  Goal goal;

  EditGoal({@required this.goal});

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();
  DateFormat dateFormat = DateFormat('MM/dd/yyyy');

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _endDate;
  TextEditingController _dateController = TextEditingController();
  var _milestoneList = <Milestone>[];
  var _themeColor;

  @override
  void initState() {
    _titleController.text = widget.goal.title;
    _descriptionController.text = widget.goal.description;
    _endDate = widget.goal.endDate;
    _dateController.text = dateFormat.format(_endDate ?? '');
    _milestoneList = widget.goal.milestones ?? <Milestone>[];
    _themeColor = widget.goal.theme ?? primaryColor;

    super.initState();
  }

  var _titleError;
  var _endDateError;

  var isSaving = false;

  var _scrollController = ScrollController();

  void _save() {
    _validateTitle();
    _validateDate();

    if (_titleError != null || _endDateError != null) return;

    isSaving = true;

    widget.goal.title = _titleController.text;
    widget.goal.description = _descriptionController.text;
    widget.goal.endDate = _endDate;
    widget.goal.milestones = _milestoneList;
    widget.goal.theme = _themeColor;

    _goalService.update(widget.goal).then(
      (_) {
        setState(() {
          Navigator.pop(context);
          isSaving = false;
        });
      },
    );
  }

  void _delete() {
    showAlertDialog(context, () {}, () {
      _goalService.delete(widget.goal).then(
        (_) {
          Navigator.pop(context);
        },
      );
    });
  }

  void _validateTitle() {
    setState(() {
      _titleError = null;

      if (_titleController.text == '') {
        _titleError = 'Title cannot be blank.';
      }
    });
  }

  void _validateDate() {
    setState(() {
      _endDateError = null;
      var endDateString = _dateController.text;

      if (endDateString == '') {
        _endDateError = 'You must select an end date.';
      }

      if (endDateString != '') {
        try {
          _endDate = dateFormat.parse(endDateString);
        } catch (e) {
          _endDateError = 'Date does not match format MM/DD/YYYY';
        }
      }
    });
  }

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
        _dateController.text = dateFormat.format(_endDate);
      });
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

  void addMilestone() {}

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25, bottom: 12),
          child: Text('Edit goal', style: heading),
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
            controller: _titleController,
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
            controller: _descriptionController,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: _dateController,
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
                  onUpdate: (i, val) =>
                      setState(() => _milestoneList[i].description = val),
                  delete: (i) => setState(() => _milestoneList.removeAt(i)),
                  onReorder: handleReorder,
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
            onChange: (color) => _themeColor = color,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text(isSaving ? 'SAVING...' : 'SAVE'),
            onPressed: isSaving ? null : () => _save(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text('DELETE'),
            onPressed: () => _delete(),
          ),
        ),
        Container(
          child: ClickableText(
            margin: EdgeInsets.only(top: 10),
            text: 'CANCEL',
            onClick: () => Navigator.pop(context),
          ),
          alignment: Alignment.center,
        ),
        Padding(
          padding: EdgeInsets.all(12.5),
        ),
      ],
    );
  }
}
