import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //used for formatting date.
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    ); //MaterialApp
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  final DateTime _displayDate = DateTime.now();
  DateTime? _selectedDay;

  //
  //

  @override
  Widget build(BuildContext context) {
    //format the DateTime using date format. There are two ways to do it. If
    //one is chosen the other line should be commented out.
    // String formattedDate = DateFormat('d-MMMM-y').format(_displayDate);
    String formattedDate = DateFormat.MMMEd().format(_displayDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Controller"),
      ), //AppBar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                color: Colors.amberAccent,
                child: Text("Today:    $formattedDate")),
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.brown,
              child: TableCalendar(
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  formatButtonVisible: false,
                  formatButtonShowsNext: false,
                  // leftChevronPadding: EdgeInsets.all(0.0),
                  // leftChevronMargin: EdgeInsets.all(0.0),
                  leftChevronIcon: Icon(
                    Icons.arrow_left,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_right,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  // rightChevronPadding: EdgeInsets.all(2.0),
                  // rightChevronMargin: EdgeInsets.all(3.0),
                  // formatButtonDecoration: BoxDecoration(
                  //   shape: BoxShape.rectangle,
                  //   color: Colors.blueAccent,
                  // ),
                ),
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
                  ),
                  isTodayHighlighted: false,
                  outsideDaysVisible: false,
                  cellMargin: const EdgeInsets.all(2.0),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  defaultDecoration: BoxDecoration(
                    color: Colors.purple,
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.rectangle,
                    //borderRadius: BorderRadius.circular(8.0),
                  ), //BoxDecoration
                ), //CalendarStyle
              ), //TableCalendar
            ), //Container
            // print(_focusedDay),
          ],
        ), //Column
      ), //SingleChildScrollView
    ); //Scaffold
  }
}
