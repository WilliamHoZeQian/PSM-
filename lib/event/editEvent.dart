// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:psm_project/model/class.dart';

import '../model/server.dart';

class EditActivityPage extends StatefulWidget {
  final Activity event;
  const EditActivityPage({required this.event});

  @override
  State<EditActivityPage> createState() => editActivitypageState();
}

class editActivitypageState extends State<EditActivityPage> {
  
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
  
  Future<void> updateActivity() async{
    DateTime date1 = DateFormat("dd/MM/yyyy").parse(startDateController.text);
    String sdate = date1.toString();
    DateTime time1 = DateFormat("HH:mm:00").parse(startTimeController.text);
    String stime = time1.toString();
    DateTime time2 = DateFormat("HH:mm:00").parse(endTimeController.text);
    String etime = time2.toString();
    
    var url = Uri.https(host, '/updateActivity.php', {'q': '{http}'});
    var response = await http.post(
        url,
        body: {
          "id": widget.event.id.toString(),
          "name": activityController.text.toString(),
          "startTime": stime,
          "endTime": etime,
          "date": sdate,
        });
    var data = await json.decode(response.body);

    if(data["update"] == true) {
      print("Update Success");
    }else {
      print("Error");
    }
  }

  @override
  void initState() {
    activityController.text = widget.event.name!;
    print(widget.event.id);
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
            onPressed: () => ShowUpdateDialog(), 
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
  ShowUpdateDialog() {
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
                      child: Text('Update', style: TextStyle(fontSize: 15)),
                      onPressed: () async{
                        if(formkey1.currentState!.validate()){
                          if(startTimeController.text != '' && endTimeController.text != ''&& activityController.text != ''){
                            await updateActivity().whenComplete(() {
                              Navigator.of(contextTime, rootNavigator: true).pop();
                              Navigator.of(context).pop(context);
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