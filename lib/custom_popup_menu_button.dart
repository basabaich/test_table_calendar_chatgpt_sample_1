import 'package:flutter/material.dart';
import './db_helper.dart';

class CustomPopupMenuButton extends StatefulWidget {
  const CustomPopupMenuButton({super.key});

  @override
  State<CustomPopupMenuButton> createState() => _CustomPopupMenuButtonState();
}

class _CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  //Textboxes controllers defined here
  final _newNoteNameController = TextEditingController();
  final _questionOnNewNoteController = TextEditingController();
  //Defining dynamic list for the data entered by the user
  List<Map<String, dynamic>> dataList = [];
  //
  //
  //This METHOD will open a Modal bottom sheet to add new notes in the calendar
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
      builder: (context) => SingleChildScrollView(
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

  @override
  void dispose() {
    // _scrollController.dispose();
    _newNoteNameController.dispose();
    _questionOnNewNoteController.dispose();
    super.dispose();
  }

  //
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
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
      },
    ); //PopupMenuButton
  }
}
