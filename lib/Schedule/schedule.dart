// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:psm_project/Schedule/taskWidget.dart';
import 'package:psm_project/data/userdata.dart';
import 'package:psm_project/model/class.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../activity/addActivity.dart';
import '../model/server.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => SchedulepageState();
}

class SchedulepageState extends State<SchedulePage> {
  
  bool isActive = false;
  final formkey1 = GlobalKey<FormState>();
  TextEditingController activityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  List record = [];
  List<Activity> activityList = [];
  List<Activity> listShowed = [];
  
  Future<void> createActivity() async{
    DateTime temp = DateFormat("dd/MM/yyyy").parse(dateController.text);
    String sdate = temp.toString();
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
  
  Future<void> getActivity() async {
    if(!activityList.isEmpty){
      activityList.clear();
    }
    try {
      var url = Uri.https(host, '/getActivity.php', {'q': '{http}'});
      var response = await http.post(
        url,
        body: {
          "userID": userID,
        });
      setState(() {
        record = json.decode(response.body);
        for(int i=0;i<record.length; i++) {
            activityList.add(
              Activity(
                id: record[i]['activityID'], 
                startTime: record[i]['startTime'],
                endTime: record[i]['endTime'],
                name: record[i]['name']
                )
            );
        }
      });
    } catch (e) {
      print(e.toString());
    }
    listShowed = activityList;
  }
  
  Future<void> DeleteActivity(int index) async{ 
    var url = Uri.https(host, '/deleteActivity.php', {'q': '{http}'});
    var response = await http.post(
        url,
        body: {
          "date": listShowed[index].date.toString()
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
    getActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5CEB8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: myCalendar(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add, 
          color: Colors.white),
          backgroundColor: Colors.red,
          onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddActivityPage(),
                    ),
                  ).whenComplete(() => getActivity()),
      ),
    );
  }
  
  Widget myCalendar(BuildContext context){
    return SfCalendar(
      view: CalendarView.month,
      initialDisplayDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      backgroundColor: Color(0xFFF5CEB8),
      dataSource: ActivityDataSource(listShowed),
      onTap: (details){
        try{
        String sdate = details.date.toString();
        if(details.appointments!.isEmpty){
          return;
        }else {
          setState(() {
            listShowed = activityList.where((element) => (
              DateFormat("dd-MM-yyyy").parse(element.startTime!).toString() == sdate.toString()
            )).toList();
          });
          showModalBottomSheet(
          context: context, 
          builder: (context) => TaskWidget(list: listShowed)
          ).whenComplete(() => getActivity());
        }
        }catch(e){
          print(e);
        }
      },
    );
  }
}