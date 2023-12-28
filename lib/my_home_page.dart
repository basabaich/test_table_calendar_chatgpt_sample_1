//import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //used for formatting date.
import 'package:table_calendar/table_calendar.dart';
import './db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './custom_next_month_button.dart';
import './custom_prev_month_button.dart';
import './custom_drawer.dart';
import 'custom_popup_menu_button.dart';
import './custom_colored_user_answer_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? _preferences;
  //Defining dynamic list for the data entered by the user
  List<Map<String, dynamic>> dataList = [];
  //Calendar format defined here
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //FocusedDay is the current date time
  DateTime _focusedDay = DateTime.now();
  //_displayDate is the current date time
  final DateTime _displayDate = DateTime.now();
  //_selectedDay is a DateTime variable
  DateTime? _selectedDay;
  //Strings which record the clicked data on the 'Drawer' is stored in these
  //variables
  String? _clickedNote;
  String? _clickedNoteQuery;

//
//

  Future<void> _initialisePreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _initialisePreferences();
  }

  // void _saveStandardValues(String key, String value) {
  //   _preferences?.setString(key, value);
  // }

  String? _getStandardValue(String key) {
    if (_preferences != null) {
      // Access SharedPreferences methods here
      return _preferences?.getString(key) ?? ''; //Returns an empty string
    } else {
      return null;
    }
  }

//creating a "fetchData" method for the edit update screen class to pass data
//edited to the main screen.
  void _fetchData() async {
    List<Map<String, dynamic>> fetchedData = await DbHelper().getData();
    setState(() {
      dataList = fetchedData;
    });
  }

//Disposing all controllers
  @override
  void dispose() {
    super.dispose();
  }

//
//
  @override
  Widget build(BuildContext context) {
    //format the DateTime using date format. There are two ways to do it. If
    //one is chosen the other line should be commented out.
    // String formattedDate1 = DateFormat('d-MMMM-y').format(_displayDate);
    String formattedDate2 = DateFormat.MMMEd().format(_displayDate);

    // Below "calendarDateYear" will show the month & year at the centre of the
    //custom header we have made here.
    String calendarDateYear = DateFormat.yMMM().format(_focusedDay);

    //Time to be shown at the extreme left of the custom heading.
    String timeFormat1 = DateFormat('hh:mm a').format(DateTime.now());

    //Fetching the existing data from the database:
    _fetchData();
    //
    //

    return Scaffold(
      drawer: const CustomDrawer(), // called custom drawer here
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          "Short calendar notes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ), //TextStyle
        ), //Text
        actions: const [
          CustomPopupMenuButton(),
        ],
      ), //AppBar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //First Block to show day, date, prev button, month, year,
            //next button, time
            Container(
              padding: const EdgeInsets.all(0.2),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Text on today's day, month & date
                  Text(formattedDate2),
                  //Previous button method
                  CustomPrevMonthButton(
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month - 1,
                        ); //DateTime
                      });
                    },
                  ), //CustomPrevMonthButton
                  //Text button to show the month & year
                  Text(
                    calendarDateYear,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 228, 137, 1),
                    ), //TextStyle
                  ), //Text
                  //Next button method
                  CustomNextMonthButton(
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month + 1,
                        ); //DateTime
                      });
                    },
                  ), //CustomNextMonthButton
                  Text(timeFormat1),
                ],
              ), //Row
            ), //Container
            const Divider(
              thickness: 2.0,
            ), //Divider
            //Second Block to show the Notes name & it's query
            Container(
              width: double.infinity,
              height: 50.0,
              padding: const EdgeInsets.all(0.1),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Show note name logic in the same position
                      if (_clickedNote != null)
                        Text('$_clickedNote')
                      else
                        Text('${_getStandardValue('key1')}'),
                      //Show note query logic in the same position
                      if (_clickedNoteQuery != null)
                        Text('$_clickedNoteQuery')
                      else
                        Text('${_getStandardValue('key2')}'),
                    ]), //Column
              ), //Padding
            ), //Container
            //Third Block to show the Calendar
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.brown,
              child: TableCalendar(
                headerVisible: false,
                //"daysOfWeekStyle" can give a background color behind the day
                //names at the top.
                daysOfWeekStyle: const DaysOfWeekStyle(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                  ), //BoxDecoration
                ), //DaysOfWeekStyle
                focusedDay: _focusedDay,
                //When "weekendDays" are "null" (or empty like here), all
                //days of the month are considered as weekdays only.
                weekendDays: const [],
                startingDayOfWeek: StartingDayOfWeek.monday,
                firstDay: DateTime.utc(2000),
                lastDay: DateTime.utc(2050),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is
                  //currently selected. If this returns true, then `day` will
                  //be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },

                calendarStyle: CalendarStyle(
                  //"defaultTextStyle" will control all texts in the cells of
                  //the calendar.
                  defaultTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ), //TextStyle
                  isTodayHighlighted: false,
                  outsideDaysVisible: false,
                  cellMargin: const EdgeInsets.all(2.0),
                  // todayDecoration: BoxDecoration(
                  //   color: Colors.blue,
                  //   shape: BoxShape.rectangle,
                  //   borderRadius: BorderRadius.circular(8.0),
                  // ), //BoxDecoration
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ), //BoxDecoration
                  defaultDecoration: BoxDecoration(
                    color: Colors.purple,
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.rectangle,
                    //borderRadius: BorderRadius.circular(8.0),
                  ), //BoxDecoration
                ), //CalendarStyle
              ), //TableCalendar
            ), //Container
            const SizedBox(
              height: 2.0,
            ), //SizedBox
            const CustomColoredUserAnswerButton(),
          ],
        ), //Column
      ), //SingleChildScrollView
    ); //Scaffold
  }
}

//For Theme Coloring use below class (see example)
//class _amberAccentPrimaryValue() {}

