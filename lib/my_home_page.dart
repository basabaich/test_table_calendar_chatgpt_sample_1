//import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //used for formatting date.
import 'package:table_calendar/table_calendar.dart';
import './db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? _preferences;
  // _initialisePreferences();
  // final DbHelper dbHelper = DbHelper();
  // late String lastClickedNoteName;
  // late String lastClickedNoteQuery;
  //Defining dynamic list for the data entered by the user
  List<Map<String, dynamic>> dataList = [];
  //Defining dynamic list for the data clicked by the user on the Drawer
  // List<Map<String, dynamic>> dataList2 = [];
  //Calendar format defined here
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //FocusedDay is the current date time
  DateTime _focusedDay = DateTime.now();
  //_displayDate is the current date time
  final DateTime _displayDate = DateTime.now();
  //_selectedDay is a DateTime variable
  DateTime? _selectedDay;
  //Textboxes controllers defined here
  final _newNoteNameController = TextEditingController();
  final _questionOnNewNoteController = TextEditingController();
  //_scrollController is defined here
  final ScrollController _scrollController = ScrollController();
  //Strings which record the clicked data on the 'Drawer' is stored in these
  //variables
  String? _clickedNote;
  String? _clickedNoteQuery;
  String? text1;
  String? text2;
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

  void _saveStandardValues(String key, String value) {
    _preferences?.setString(key, value);
  }

  String? _getStandardValue(String key) {
    if (_preferences != null) {
      // Access SharedPreferences methods here
      return _preferences?.getString(key) ?? ''; //Returns an empty string
    } else {
      return null;
    }
  }

  //This will open a Modal bottom sheet to add new notes in the calendar
  void _openAddMainOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      //In a "showModalBottomSheet()" property always call single child scroll
      //view & then call a container to it's child. In this container, the
      //padding will be "Edgeinsets.Only()" , without a constant at the start
      //and call within it "bottom: MediaQuery.of(context).viewInsets.bottom,".
      //With this we can always keep the bottom modal sheet's all widgets
      //above the pop up keyboard. Also remember to call the bottom modal sheet
      // property "isScrollControlled: true," , without which keeping all
      //widgets above the keyboard is not possible.
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 15.0,
            right: 15.0,
            left: 15.0,
          ),
          //The height is disabled here, as we don't want a specific height of
          //bottom modal sheet here. If you want to keep a specific height
          // of bottom modal sheet, you should define it here and a trial &
          //error method to be done to check which height is suitable.
          //Generally height of 75.0 is very small & height of 550 is just
          //midway.
          //-----------------------------------------------
          //height: 580,
          //-----------------------------------------------
          child: Column(
            children: [
              TextField(
                controller: _newNoteNameController,
                decoration: const InputDecoration(
                  label: Text(
                      //Creating text field for inputs
                      'Name Of New Note :'),
                ), //InputDecoration
              ), //TextField
              TextField(
                controller: _questionOnNewNoteController,
                decoration: const InputDecoration(
                  label: Text(
                      //Creating text field for inputs
                      'Question On New Note ?'),
                ), //Inputdecoration
              ), //TextField
              ElevatedButton(
                onPressed: () {
                  _saveData(); //calling "_saveData()" method
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.amberAccent),
                ),
                child: const Text('Save New Note Properties'),
              ), //ElevatedButton
            ],
          ), //Column
        ), //Container
      ), //SingleChildScrollView
    );
  }

  //
  //
  void _saveData() async {
    final noteName = _newNoteNameController.text;
    final noteQuery = _questionOnNewNoteController.text;
    int insertId = await DbHelper().insertUser(noteName, noteQuery);
    debugPrint(insertId.toString()); //This line is for testing purpose only
    //Refresh data after saving it, otherwise it will not display
    List<Map<String, dynamic>> updatedData = await DbHelper().getData();
    setState(() {
      dataList = updatedData;
    });
    //After updation set the controller values to null to clear the text fields
    _newNoteNameController.clear();
    _questionOnNewNoteController.text = '';
  }

  //
  //

//

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
    _scrollController.dispose();
    _newNoteNameController.dispose();
    _questionOnNewNoteController.dispose();
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
    //
    //

    return Scaffold(
      //update data in this screen
      //
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 1.7, //Size 220.0 is suitable
        backgroundColor: Colors.white24,
        child: Container(
          padding: const EdgeInsets.only(top: 0.7, left: 0.7, right: 1.0),
          color: const Color.fromARGB(240, 224, 223, 223),
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: dataList.length,
              itemBuilder: (context, index) => Container(
                color: const Color.fromARGB(255, 206, 124, 2),
                padding: const EdgeInsets.only(right: 1.5, left: 1.0),
                child: ListTile(
                  dense: true,
                  title: InkWell(
                    onTap: () {
                      _clickedNote = dataList[index]['noteName'];
                      _clickedNoteQuery = dataList[index]['noteQuery'];
                      _saveStandardValues('key1', _clickedNote!);
                      _saveStandardValues('key2', _clickedNoteQuery!);
                      Navigator.of(context).pop(); //This will close the drawer
                    },
                    child: Text(dataList[index]['noteName']),
                  ), //InkWell
                ), //ListTile
              ), //Container
            ), //ListView.builder
          ), //ScrollBar
        ), //Container
      ), //Drawer

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
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                onTap: _openAddMainOverlay, //Opening the bottom modal sheet
                child: const ListTile(
                  leading: Icon(
                    Icons.edit_document,
                    size: 18.0,
                  ),
                  title: Text(
                    "Add new note",
                  ), //Text
                ), //ListTile
              ), //PopupMenuItem
              const PopupMenuItem(
                value: 1,
                child: Text('Setting'),
              ), //PopupMenuItem
              const PopupMenuItem(
                value: 2,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0.2),
                  leading: Icon(
                    Icons.home,
                    size: 30.0,
                  ), //Icon
                  title: Text("Reports"),
                ), //ListTile
              ), //PopupMenuItem
              const PopupMenuItem(
                value: 3,
                child: Text('Edit Notes'),
              ), //PopupMenuItem
              const PopupMenuItem(
                value: 4,
                child: Text('Delete Notes'),
              ), //PopupMenuItem
            ];
          }), //PopupMenuItem
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
            Container(
              padding: const EdgeInsets.all(10.0),
              width: double.infinity, //width of 3rd Block
              height: 80.0,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // visualDensity:
                      //     const VisualDensity(vertical: 1.0, horizontal: 1.0),
                      // minimumSize: const Size(1, 1),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('R'),
                  ), //ElevatedButton
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('G'),
                  ), //ElevatedButton
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('B'),
                  ), //ElevatedButton
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Y'),
                  ), //ElevatedButton
                ],
              ), //Row
            ) //Container
            // print(_focusedDay),
          ],
        ), //Column
      ), //SingleChildScrollView
    ); //Scaffold
  }
}

//For Theme Coloring use below class (see example)
//class _amberAccentPrimaryValue() {}

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
    ); //TextButton
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
    ); //TextButton
  }
}
