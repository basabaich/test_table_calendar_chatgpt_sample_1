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
    // String formattedDate1 = DateFormat('d-MMMM-y').format(_displayDate);
    String formattedDate2 = DateFormat.MMMEd().format(_displayDate);

    // Below "calendarDateYear" will show the month & year at the centre of the
    //custom header we have made here.
    String calendarDateYear = DateFormat.yMMM().format(_focusedDay);

    //Time to be shown at the extreme left of the custom heading.
    String timeFormat1 = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      drawer: Drawer(
        width: 175.0,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 55.0, bottom: 25, left: 55.0),
              color: Colors.yellow,
              child: const Text(
                "Menu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextButton(onPressed: () {}, child: const Text("Add new note")),
            const SizedBox(height: 20.0),
            TextButton(onPressed: () {}, child: const Text("Reports")),
            const SizedBox(height: 20.0),
            TextButton(onPressed: () {}, child: const Text("Delete notes")),
            const SizedBox(height: 20.0),
            TextButton(onPressed: () {}, child: const Text("Edit notes")),
            const SizedBox(height: 20.0),
            TextButton(onPressed: () {}, child: const Text("Settings")),
            const SizedBox(height: 20.0),
            TextButton(onPressed: () {}, child: const Text("Feedback")),
            const SizedBox(height: 20.0),
            TextButton(onPressed: () {}, child: const Text("Remove Ads"))
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          "Short calendar notes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ), //AppBar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(1.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ),
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
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ), //BoxDecoration
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
            // print(_focusedDay),
          ],
        ), //Column
      ), //SingleChildScrollView
    ); //Scaffold
  }
}

class CustomPrevMonthButton extends StatelessWidget {
  const CustomPrevMonthButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Icon(
        Icons.arrow_back_ios_new_sharp,
      ), //Icon
    ); //ElevatedButton
  }
}

class CustomNextMonthButton extends StatelessWidget {
  const CustomNextMonthButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Icon(
        Icons.arrow_forward_ios_sharp,
      ), //Icon
    ); //ElevatedButton
  }
}
