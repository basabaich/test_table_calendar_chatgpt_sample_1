import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './db_helper.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  SharedPreferences? _preferences;
  //Defining dynamic list for the data entered by the user
  List<Map<String, dynamic>> dataList = [];
  //_scrollController is defined here
  final ScrollController _scrollController = ScrollController();
  //Strings which record the clicked data on the 'Drawer' is stored in these
  //variables
  String? _clickedNote;
  String? _clickedNoteQuery;
  // String? text1;
  // String? text2;
  //
  //
  void _saveStandardValues(String key, String value) {
    _preferences?.setString(key, value);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _initialisePreferences();
  }

  Future<void> _initialisePreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //creating a "fetchData" method for the edit update screen class to pass data
//edited to the main screen.
  void _fetchData() async {
    List<Map<String, dynamic>> fetchedData = await DbHelper().getData();
    setState(() {
      dataList = fetchedData;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _newNoteNameController.dispose();
    // _questionOnNewNoteController.dispose();
    super.dispose();
  }

  //
  //
  @override
  Widget build(BuildContext context) {
    //Fetching the existing data from the database:
    _fetchData();
    //
    //
    return Drawer(
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
    );
  }
}
