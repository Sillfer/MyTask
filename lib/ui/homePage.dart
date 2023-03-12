import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/controllers/task_controller.dart';
import 'package:flutter_notification/services/theme_services.dart';
import 'package:flutter_notification/ui/add_task_bar.dart';
import 'package:flutter_notification/ui/task_tile.dart';
import 'package:flutter_notification/ui/theme.dart';
import 'package:flutter_notification/ui/widgets/button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('Loading...');
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (_, index) {
              final task =
                  snapshot.data?.docs[index].data() as Map<String, dynamic>;
              final taskMap = task != null ? Task.fromMap(task) : null;
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            // onTap: () {
                            //   _showTaskOptions(context, taskMap!);
                            // },
                            child: TaskTile(taskMap),
                          )
                        ],
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }

  _addDateBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Get.isDarkMode ? blueClr : darkBlueClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        onDateChange: (date) {
          // New date selected
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: '+ Add Task',
            onPressed: () => Get.to(
              () => const AddTaskPage(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 500),
            ),
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
              title: 'Theme Changed',
              body: Get.isDarkMode ? 'Light Mode' : 'Dark Mode');
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
          size: 20,
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
