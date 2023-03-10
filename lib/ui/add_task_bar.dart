import 'package:flutter/material.dart';
import 'package:flutter_notification/ui/theme.dart';
import 'package:flutter_notification/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String endTime = "9:30 PM";
  String _startTime = DateFormat('hh:mm a').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
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
                  controller: null,
                  widget: null),
              MyInputField(
                  Title: "Note",
                  hint: "Enter your Note",
                  controller: null,
                  widget: null),
              MyInputField(
                Title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                controller: null,
                widget: IconButton(
                  icon: const Icon(Icons.calendar_month_sharp,
                      color: Colors.grey),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    });
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
                        widget: null),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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
}

// _getDateFromUser() async {
//   DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: _selectedDate,
//     firstDate: DateTime(2001),
//     lastDate: DateTime(2025),
//   );
//   if (picked != null) {
//     setState(() {
//       _selectedDate = picked;
//     });
//   }
// }
