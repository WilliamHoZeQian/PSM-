// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:psm_project/data/userdata.dart';
import 'package:psm_project/model/class.dart';

import '../model/server.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => addActivitypageState();
}

class addActivitypageState extends State<AddActivityPage> {
  
  DateTime now = DateTime.now();
  bool isActive = false;
  final formkey1 = GlobalKey<FormState>();
  TextEditingController activityController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  List record = [];
  List<Activity> activityList = [];
  List<Activity> listShowed = [];
  
  Future<void> createActivity() async{
    DateTime date1 = DateFormat("dd/MM/yyyy").parse(startDateController.text);
    String sdate = date1.toString();
    DateTime time1 = DateFormat("HH:mm:00").parse(startTimeController.text);
    String stime = time1.toString();
    DateTime time2 = DateFormat("HH:mm:00").parse(endTimeController.text);
    String etime = time2.toString();
    
    var url = Uri.https(host, '/insertActivity.php', {'q': '{http}'});
    var response = await http.post(
        url,
        body: {
          "userID": userID.toString(),
          "name": activityController.text.toString(),
          "startTime": stime,
          "endTime": etime,
          "date": sdate,
        });
    var data = await json.decode(response.body);

    if(data["upload"] == true) {
      print("Create Success");
    }else {
      print("Upload invoice error");
    }
  }
  
  Future<void> DeleteActivity(int index) async{ 
    var url = Uri.https(host, '/deleteActivitySpecific.php', {'q': '{http}'});
    var response = await http.post(
        url,
        body: {
          "id": listShowed[index].id.toString()
        });
    var data = json.decode(response.body);
    if(data["delete"] == true) {
      Fluttertoast.showToast(
        msg: 'Activity Deleted',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }else{
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Activity Delete Failed',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  void initState() {
    //getActivity();
    startDateController.text = DateFormat("dd/MM/yyyy").format(now);
    startTimeController.text = DateFormat("HH:mm:00").format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5CEB8),
        elevation: 0,
        centerTitle: true,
        leading: CloseButton(color: Colors.black),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5CEB8),
              shadowColor: Colors.transparent
            ),
            onPressed: () => ShowCreateDialog(), 
            icon: Icon(Icons.done, color: Colors.black),
              label: Text('Save', style: TextStyle(color: Colors.black),),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: formkey1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Add title'
                ),
                onFieldSubmitted: (_) {},
                validator: (title){
                  title != null && title.isEmpty ? 'Title cannot be empty' : null;
                },
                controller: activityController,
              ),
              SizedBox(height: 20),
              TextField(
                controller: startDateController,
                readOnly: true,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: "From",
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range_outlined,),
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        currentTime: DateTime.now(),
                        onConfirm: (newTime){
                          setState(() {
                            startDateController.text = DateFormat("dd/MM/yyyy").format(newTime);
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: height/2.3,
                    child: TextField(
                      controller: startTimeController,
                      readOnly: true,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        labelText: "Start time",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.date_range_outlined,),
                          onPressed: () {
                            DatePicker.showTimePicker(
                              context,
                              showSecondsColumn: false,
                              currentTime: DateTime.now(),
                              onConfirm: (newTime){
                                setState(() {
                                  startTimeController.text = DateFormat("HH:mm:00").format(newTime);
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: height/2.3,
                    child: TextField(
                      controller: endTimeController,
                      readOnly: true,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        labelText: "End time",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.date_range_outlined,),
                          onPressed: () {
                            DatePicker.showTimePicker(
                              context,
                              showSecondsColumn: false,
                              currentTime: DateTime.now(),
                              onConfirm: (newTime){
                                setState(() {
                                  endTimeController.text = DateFormat("HH:mm:00").format(newTime);
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ]
              )
            ],
          ),
        ),
      )
    );
  }
 
  /**
   * Pop-up dialog for create activity
   */
  ShowCreateDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext contextTime) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(8),
              content: Text("Are you sure to create this activity?"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400]
                      ),
                      child: Text('Cancel', style: TextStyle(fontSize: 15)),
                      onPressed: (){
                        Navigator.of(contextTime, rootNavigator: true).pop();
                      }, 
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]
                      ),
                      child: Text('Create', style: TextStyle(fontSize: 15)),
                      onPressed: () async{
                        if(formkey1.currentState!.validate()){
                          if(startTimeController.text != '' && endTimeController.text != ''&& activityController.text != ''){
                            await createActivity().whenComplete(() {
                              Navigator.of(contextTime, rootNavigator: true).pop();
                              Navigator.of(context).pop(context);
                              activityController.clear();
                              startTimeController.clear();
                              endTimeController.clear();
                            });
                          }
                          else{
                            Fluttertoast.showToast(
                              msg: 'Please key in all the field',
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        }
                      }, 
                    ),
                  ],
                )
              ],
            );
      },
    );
  }
}