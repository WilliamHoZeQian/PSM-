// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:psm_project/model/class.dart';
import '../model/server.dart';
import 'editEvent.dart';

class EventPage extends StatefulWidget {
  final Activity event;
  const EventPage({required this.event});

  @override
  State<EventPage> createState() => EventpageState();
}

class EventpageState extends State<EventPage> {
  
  bool isActive = false;
  final formkey1 = GlobalKey<FormState>();
  TextEditingController activityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  List record = [];
  List<Activity> activityList = [];
  List<Activity> listShowed = [];
  
  
  Future<void> DeleteActivity() async{ 
    var url = Uri.https(host, '/deleteActivitySpecific.php', {'q': '{http}'});
    var response = await http.post(
        url,
        body: {
          "id": widget.event.id.toString()
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
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5CEB8),
              shadowColor: Colors.transparent
            ),
            onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> EditActivityPage(event: widget.event))
          ).whenComplete(() => Navigator.of(context).pop(context)), 
            icon: Icon(Icons.edit, color: Colors.black),
              label: Text('Edit', style: TextStyle(color: Colors.black),),
            ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5CEB8),
              shadowColor: Colors.transparent
            ),
            onPressed: () => ShowDeleteDialog(), 
            icon: Icon(Icons.delete, color: Colors.black),
              label: Text('Delete', style: TextStyle(color: Colors.black),),
            )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          buildDateTime(widget.event),
          SizedBox(height: 32),
          Text(widget.event.name!,
          style: TextStyle(
            fontSize: 24,
          ),),
        ],
      )
    );
  }
  
  Widget buildDateTime(Activity event){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text('From'),
            ),
            Container(
              child: Text(widget.event.startTime!),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text('To'),
            ),
            Container(
              child: Text(widget.event.endTime!),
            )
          ],
        ),
      ],
    );
  }
  
  ShowDeleteDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext contextTime) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(8),
              content: Text("Are you sure to delete this activity?"),
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
                      child: Text('Delete', style: TextStyle(fontSize: 15)),
                      onPressed: () async{
                        await DeleteActivity().whenComplete(() {
                          Navigator.of(contextTime, rootNavigator: true).pop();
                          Navigator.of(context).pop(context);
                        });
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