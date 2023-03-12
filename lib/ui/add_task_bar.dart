import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/controllers/task_controller.dart';
import 'package:flutter_notification/models/task.dart';
import 'package:flutter_notification/ui/theme.dart';
import 'package:flutter_notification/ui/widgets/button.dart';
import 'package:flutter_notification/ui/widgets/input_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(hours: 1)))
      .toString();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> _remindList = [
    5,
    10,
    15,
    30,
    45,
  ];
  String _selectedRepeat = 'Never';
  List<String> _repeatList = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly',
  ];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputField(
                  Title: "Title",
                  hint: "Enter your Title",
                  controller: _titleController,
                  widget: null),
              MyInputField(
                  Title: "Note",
                  hint: "Enter your Note",
                  controller: _noteController,
                  widget: null),
              MyInputField(
                Title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                controller: null,
                widget: IconButton(
                  icon: const Icon(Icons.calendar_month_sharp,
                      color: Colors.grey),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                        Title: "Start Time",
                        hint: _startTime,
                        controller: null,
                        widget: IconButton(
                          icon: const Icon(Icons.access_time_sharp,
                              color: Colors.grey),
                          onPressed: () {
                            _getTimeFromUser(
                              isStartTime: true,
                            );
                          },
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyInputField(
                        Title: "End Time",
                        hint: _endTime,
                        controller: null,
                        widget: IconButton(
                          icon: const Icon(Icons.access_time_sharp,
                              color: Colors.grey),
                          onPressed: () {
                            _getTimeFromUser(
                              isStartTime: false,
                            );
                          },
                        )),
                  ),
                ],
              ),
              MyInputField(
                Title: "Remind",
                hint: '$_selectedRemind minutes before',
                controller: null,
                widget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    items:
                        _remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString(),
                            style: TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                  ),
                ),
              ),
              MyInputField(
                Title: "Repeat",
                hint: _selectedRepeat,
                controller: null,
                widget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    items: _repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _colorPallet(),
                  MyButton(label: "Create Task", onPressed: () => _validate()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validate() async {
    if (_titleController.text.isNotEmpty) {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('tasks').add({
        'title': _titleController.text,
        'note': _noteController.text,
        'date': DateFormat.yMd().format(_selectedDate),
        'startTime': _startTime,
        'endTime': _endTime,
        'remind': _selectedRemind,
        'repeat': _selectedRepeat,
        'color': _selectedColor,
        'isCompleted': false,
      });
      print(_titleController.text);
      Get.back();
    } else {
      Get.snackbar("Error", "All fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.pink,
          ));
    }
  }

  _addTaskToDb() async {
    await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: false,
      ),
    );
  }

  _colorPallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 8.0),
        Wrap(
            children: List<Widget>.generate(3, (int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
                print(_selectedColor);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircleAvatar(
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : yellowClr,
                radius: 14,
                child: _selectedColor == index
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      )
                    : Container(),
              ),
            ),
          );
        }))
      ],
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor:
          Get.isDarkMode ? context.theme.colorScheme.background : Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_sharp,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: const AssetImage('images/Among-US.png'),
        ),
        const SizedBox(width: 20),
      ],
      // title: const Text('Home Page'),
      centerTitle: true,
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: false), // set to 12 hour format
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = DateFormat('hh:mm a')
              .format(DateTime(_selectedDate.year, _selectedDate.month,
                  _selectedDate.day, picked.hour, picked.minute))
              .toString();
        } else {
          _endTime = DateFormat('hh:mm a')
              .format(DateTime(_selectedDate.year, _selectedDate.month,
                  _selectedDate.day, picked.hour, picked.minute))
              .toString();
        }
      });
    }
  }

  // _getEndTimeFromUser() async {
  //   TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     // set to 12 hour format
  //     builder: (BuildContext context, Widget? child) {
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _endTime = DateFormat('hh:mm a').format(DateTime(
  //               _selectedDate.year,
  //               _selectedDate.month,
  //               _selectedDate.day,
  //               picked.hour,
  //               picked.minute))
  //           .toString();
  //     });
  //   }
  // }

  _getDateFromUser() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
